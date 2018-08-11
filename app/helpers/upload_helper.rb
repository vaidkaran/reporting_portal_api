module UploadHelper

  # Sets @report. Returns nil is something goes wrong.
  def save_report
    # test_category_id to be passed in params
    test_category = TestCategory.find(params[:test_category_id])
    unless test_category
      render test_category_not_found_json and return(nil)
    end

    if current_user
      project = current_user.projects.find(TestCategory.find(params[:test_category_id]).project_id)
    elsif current_org_user
      if current_org_user.admin
        project = current_org_user.organisation.projects.find_by(TestCategory.find(params[:test_category_id]).project_id)
      else
        project = current_org_user.projects.find_by(TestCategory.find(params[:test_category_id]).project_id)
      end
    else
      return nil
    end

    unless(project)
      render project_not_found_json and return(nil)
    end

    report = test_category.reports.new
    unless report.save
      render failure_json and return(nil)
    end

    @report = report
  end

  def success_json
    {json: {success: 'true', message: 'Report successfully uploaded'}}
  end

  def failure_json
    {json: {success: 'false', message: 'Report could not be uploaded', error: 'Something went wrong'}}
  end

  def project_not_found_json
    {json: {success: 'false', message: 'Report could not be uploaded', error: 'Project not found. Make sure you\'re passing the correct test_category_id'}}
  end

  def test_category_not_found_json
    {json: {success: 'false', message: 'Report could not be uploaded', error: 'Test category not found'}}
  end

  # Format of the hash returned by parse_junit_xml
  #
  # {junit_test_suite_group:
  #     { params: {name: <string>, _errors: <int>, tests: <int>, failures: <int>, time: <int>}},
  #     junit_test_suites:
  #         [
  #           {
  #           params: {name: <string>, tests: <int>, disabled: <int>, _errors: <int>, failures: <int>, hostname: <int>, testsuiteid: <int>, package: <string>, skipped: <int>, time: <int>, timestamp: <string>, system_out: <string>, system_err: <string>},
  #           junit_test_suite_properties: [ {params: {name: <string>, value: <string>}} ],
  #           junit_test_cases: [ {params: {name: <string>, assertions: <int>, classname: <string>, status: <string>, time: <int>, skipped: <int>}} ]
  #           }
  #         ]
  # }

  # Parses the xml file and returns a hash to be consumed by the controller
  def parse_junit_xml(f)
    report = {}
    report[:junit_test_suite_group] = {}
    report[:junit_test_suite_group][:params] = {}
    report[:junit_test_suite_group][:junit_test_suites] = []

    doc = Nokogiri::XML(f)

    testsuite_group = doc.xpath('/testsuites').first
    report[:junit_test_suite_group][:params][:name]     = testsuite_group.attr('name')
    report[:junit_test_suite_group][:params][:_errors]  = testsuite_group.attr('errors').to_i
    report[:junit_test_suite_group][:params][:tests]    = testsuite_group.attr('tests').to_i
    report[:junit_test_suite_group][:params][:failures] = testsuite_group.attr('failures').to_i
    report[:junit_test_suite_group][:params][:time]     = testsuite_group.attr('time').to_i

    testsuites = doc.xpath('//testsuite')
    testsuites.each do |testsuite|
      tempvar_testsuite = {}
      tempvar_testsuite[:params] = {}
      tempvar_testsuite[:params][:name]        = testsuite.attr('name')
      tempvar_testsuite[:params][:tests]       = testsuite.attr('tests').to_i
      tempvar_testsuite[:params][:disabled]    = testsuite.attr('disabled').to_i
      tempvar_testsuite[:params][:_errors]     = testsuite.attr('errors').to_i
      tempvar_testsuite[:params][:failures]    = testsuite.attr('failures').to_i
      tempvar_testsuite[:params][:hostname]    = testsuite.attr('hostname')
      tempvar_testsuite[:params][:testsuiteid] = testsuite.attr('id').to_i
      tempvar_testsuite[:params][:package]     = testsuite.attr('package')
      tempvar_testsuite[:params][:skipped]     = testsuite.attr('skipped').to_i
      tempvar_testsuite[:params][:time]        = testsuite.attr('time').to_i
      tempvar_testsuite[:params][:timestamp]   = testsuite.attr('timestamp')
      tempvar_testsuite[:params][:system_out]  = testsuite.xpath('./system-out').text
      tempvar_testsuite[:params][:system_err]  = testsuite.xpath('./system-err').text

      tempvar_testsuite[:junit_test_suite_properties] = []
      testsuite.xpath('./properties/property').each do |property|
        tempvar_testsuite[:junit_test_suite_properties] << {params: {name: property.attr('name'), value: property.attr('value')}}
      end

      tempvar_testsuite[:junit_test_cases] = []
      testsuite.xpath('./testcase').each do |testcase|
        tempvar_testcase = {}
        tempvar_testcase[:params] = {}
        tempvar_testcase[:params][:name]            = testcase.attr('name')
        tempvar_testcase[:params][:assertions]      = testcase.attr('assertions').to_i
        tempvar_testcase[:params][:classname]       = testcase.attr('classname')
        tempvar_testcase[:params][:status]          = testcase.attr('status')
        tempvar_testcase[:params][:time]            = testcase.attr('time').to_i
        tempvar_testcase[:params][:skipped]         = testcase.xpath('./skipped').text
        unless testcase.xpath('./error').empty?
          tempvar_testcase[:params][:error_message]   = testcase.xpath('./error').first.attr('message')
          tempvar_testcase[:params][:error_type]      = testcase.xpath('./error').first.attr('type')
          tempvar_testcase[:params][:error_text]      = testcase.xpath('./error').first.text
        end
        unless testcase.xpath('./failure').empty?
          tempvar_testcase[:params][:failure_message] = testcase.xpath('./failure').first.attr('message')
          tempvar_testcase[:params][:failure_type]    = testcase.xpath('./failure').first.attr('type')
          tempvar_testcase[:params][:failure_text]    = testcase.xpath('./failure').first.text
        end
        tempvar_testcase[:params][:system_out] = testcase.xpath('./system-out').first.text unless testcase.xpath('./system-out').empty?
        tempvar_testcase[:params][:system_err] = testcase.xpath('./system-err').first.text unless testcase.xpath('./system-err').empty?

        tempvar_testsuite[:junit_test_cases] << tempvar_testcase
      end
      report[:junit_test_suite_group][:junit_test_suites] << tempvar_testsuite
    end

    return report
  end

  def parse_testng_xml(f)
    report = {}
    report[:testng_results] = {}
    report[:testng_results][:params] = {}
    report[:testng_results][:testng_suites] = []

    doc = Nokogiri::XML(f)
    testng_results = doc.xpath('/testng-results').first
    report[:testng_results][:params][:skipped] = testng_results.attr('skipped').to_i
    report[:testng_results][:params][:failed] = testng_results.attr('failed').to_i
    report[:testng_results][:params][:ignored] = testng_results.attr('ignored').to_i
    report[:testng_results][:params][:passed] = testng_results.attr('passed').to_i
    report[:testng_results][:params][:reporter_output] = testng_results.xpath('./reporter-output').text

    testng_results.xpath('./suite').each do |testng_suite|
      temp_testsuite = {}
      temp_testsuite[:params] = {}
      temp_testsuite[:params][:name] = testng_suite.attr('name')
      temp_testsuite[:params][:duration_ms] = testng_suite.attr('duration-ms').to_i
      temp_testsuite[:params][:started_at] = testng_suite.attr('started-at')
      temp_testsuite[:params][:finished_at] = testng_suite.attr('finished-at')

      temp_testsuite[:testng_groups] = []
      testng_suite.xpath('./groups/group').each do |testng_group|
        temp_group = {}
        temp_group[:params] = {}
        temp_group[:params][:name] = testng_group.attr('name')

        temp_group[:testng_methods] = []
        testng_group.xpath('./method').each do |testng_method|
          temp_method = {}
          temp_method[:params] = {}
          temp_method[:params][:signature] = testng_method.attr('signature')
          temp_method[:params][:name] = testng_method.attr('name')
          temp_method[:params][:class] = testng_method.attr('class')
          temp_group[:testng_methods] << temp_method
        end
        temp_testsuite[:testng_groups] << temp_group
      end

      temp_testsuite[:testng_tests] = []
      testng_suite.xpath('./test').each do |testng_test|
        temp_test = {}
        temp_test[:params] = {}
        temp_test[:params][:name] = testng_test.attr('name')
        temp_test[:params][:duration_ms] = testng_test.attr('duration-ms')
        temp_test[:params][:started_at] = testng_test.attr('started_at')
        temp_test[:params][:finished_at] = testng_test.attr('finished_at')

        temp_test[:testng_class] = []
        testng_test.xpath('./class').each do |testng_class|
          temp_class = {}
          temp_class[:params] = {}
          temp_class[:params][:name] = testng_class.attr('name')

          temp_class[:testng_test_method] = []
          testng_class.xpath('./test-method').each do |testng_test_method|
            temp_test_method = {}
            temp_test_method[:params] = {}
            temp_test_method[:params][:status] = testng_test_method.attr('status')
            temp_test_method[:params][:signature] = testng_test_method.attr('signature')
            temp_test_method[:params][:test_instance_name] = testng_test_method.attr('test-instance-name')
            temp_test_method[:params][:name] = testng_test_method.attr('name')
            temp_test_method[:params][:is_config] = testng_test_method.attr('is-config')
            temp_test_method[:params][:duration_ms] = testng_test_method.attr('duration-ms')
            temp_test_method[:params][:started_at] = testng_test_method.attr('started-at')
            temp_test_method[:params][:finished_at] = testng_test_method.attr('finished-at')
            temp_test_method[:params][:data_provider] = testng_test_method.attr('data-provider')
            temp_test_method[:params][:description] = testng_test_method.attr('description')
            temp_test_method[:params][:reporter_output] = testng_test_method.attr('reporter-output')

            temp_test_method[:testng_test_method_params] = []
            testng_test_method.xpath('./params/param').each do |test_method_param|
              temp_test_params = {}
              temp_test_params[:params] = {}
              temp_test_params[:params][:index] = test_method_param.attr('index')
              temp_test_params[:params][:value] = test_method_param.xpath('./value').text
              temp_test_method[:testng_test_method_params] << temp_test_params
            end

            temp_test_method[:testng_test_method_exception] = []
            testng_test_method.xpath('./exception').each do |test_method_exception|
              temp_test_exception = {}
              temp_test_exception[:params] = {}
              temp_test_exception[:params][:class] = test_method_exception.attr('class')
              temp_test_exception[:params][:message] = test_method_exception.xpath('./message').text
              temp_test_exception[:params][:full_stacktrace] = test_method_exception.xpath('./full_stacktrace').text
              temp_test_method[:testng_test_method_exception] << temp_test_exception
            end
            temp_class[:testng_test_method] << temp_test_method
          end
          temp_test[:testng_class] << temp_class
        end
        temp_testsuite[:testng_tests] << temp_test
      end
      report[:testng_results][:testng_suites] << temp_testsuite
    end

    reportfile = File.new('hello', 'w+')
    reportfile.puts(report)
    reportfile.close


    require 'pry'; binding.pry

    puts 'hi'
  end


end

