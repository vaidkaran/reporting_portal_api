module UploadHelper

  # Returns a report object. Returns nil is something goes wrong.
  def save_report
    # Check if project and test_category are passed correctly
    if current_user
      project = current_user.projects.find_by(name: params[:project_name].strip)
    elsif current_org_user
      if current_org_user.admin
        project = current_org_user.organisation.projects.find_by(name: params[:project_name].strip)
      else
        project = current_org_user.projects.find_by(name: params[:project_name].strip)
      end
    else
      return nil
    end

    unless(project)
      render project_not_found_json and return(nil)
    end
    test_category = project.test_categories.find_by(name: params[:test_category].strip)
    unless test_category
      render test_category_not_found_json and return(nil)
    end

    report = test_category.reports.new(_type: params[:report_type].strip, format: params[:report_format].strip)
    unless report.save
      render failure_json and return(nil)
    end

    return report
  end

  def success_json
    {json: {success: 'true', message: 'Report successfully uploaded'}}
  end

  def failure_json
    {json: {success: 'false', message: 'Report could not be uploaded', error: 'Something went wrong'}}
  end

  def project_not_found_json
    {json: {success: 'false', message: 'Report could not be uploaded', error: 'Project not found. Make sure you\'re passing the correct project name'}}
  end

  def test_category_not_found_json
    {json: {success: 'false', message: 'Report could not be uploaded', error: 'Test category not found for the specified project name. Make sure you\'re passing the correct test category name'}}
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


end

