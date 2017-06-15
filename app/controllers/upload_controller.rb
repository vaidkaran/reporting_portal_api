class UploadController < ApplicationController
  include UploadHelper
  before_action :authenticate_user!

  def mocha
    #require 'pry'; binding.pry

    failure_json = {json: {success: 'false', message: 'Report could not be uploaded'}}
    success_json = {json: {success: 'true', message: 'Report successfully uploaded'}}
    project_not_found_json       = {json: {success: 'false', message: 'Project not found. Make sure you\'re passing the correct project name'}}
    test_category_not_found_json = {json: {success: 'true', message: 'Test category not found for the specified project name. Make sure you\'re passing the correct test category name'}}

    # Check if project and test_category are passed correctly
    project = current_user.projects.find_by(name: params[:project_name].strip)
    unless(project)
      render project_not_found_json and return
    end
    test_category = project.test_categories.find_by(name: params[:test_category].strip)
    unless test_category
      render test_category_not_found_json and return
    end

    report = test_category.reports.new(_type: params[:report_type].strip, format: params[:report_format].strip)
    unless report.save
      render failure_json and return
    end

    begin
      file = File.read params[:upload].tempfile
      report_data = JSON.parse(file) # report_data is a Hash

      mocha_stat_params = report_data['stats']
      mocha_test_params_array = report_data['tests']
      mocha_pass_params_array = report_data['passes']
      mocha_failure_params_array = report_data['failures']

      mocha_stat = report.build_mocha_stat(mocha_stat_params)
      unless mocha_stat.save
        report.destroy # Destroy the report and all the associated models if something goes wrong
        render(failure_json) and return
      end

      mocha_test_params_array.each do |mocha_test_params|
        mocha_test = report.mocha_tests.new(mocha_test_params)
        unless mocha_test.save
          report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end
      end

      mocha_pass_params_array.each do |mocha_pass_params|
        mocha_pass = report.mocha_passes.new(mocha_pass_params)
        unless mocha_pass.save
          report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end
      end

      mocha_failure_params_array.each do |mocha_failure_params|
        mocha_failure = report.mocha_failures.new(mocha_failure_params)
        unless mocha_failure.save
          report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end
      end

      render(success_json)
    rescue Exception=>e
      report.destroy # Destroy the report and all the associated models
      render(failure_json) and return
    end

    puts 'test'
  end

  def junit
    failure_json = {json: {success: 'false', message: 'Report could not be uploaded'}}
    success_json = {json: {success: 'true', message: 'Report successfully uploaded'}}
    project_not_found_json       = {json: {success: 'false', message: 'Project not found. Make sure you\'re passing the correct project name'}}
    test_category_not_found_json = {json: {success: 'true', message: 'Test category not found for the specified project name. Make sure you\'re passing the correct test category name'}}

    # Check if project and test_category are passed correctly
    project = current_user.projects.find_by(name: params.require(:project_name).strip)
    unless(project)
      render project_not_found_json and return
    end
    test_category = project.test_categories.find_by(name: params.require(:test_category).strip)
    unless test_category
      render test_category_not_found_json and return
    end


    report = test_category.reports.new(_type: params.require(:report_type), format: params.require(:report_format))
    unless report.save
      render failure_json and return
    end

    begin
      file = params[:upload].tempfile
      @report_hash = parse_junit_xml(file)

      junit_tsg = JunitTestSuiteGroup.new(@report_hash[:junit_test_suite_group][:params])
      report.junit_test_suite_group = junit_tsg
      if junit_tsg.save # Save junit_test_suite_group in db. Proceed only if it succeeds

        @report_hash[:junit_test_suite_group][:junit_test_suites].each do |testsuite| # Iterate through all the test_suites
          junit_ts = junit_tsg.junit_test_suites.new(testsuite[:params])
          if junit_ts.save # Save junit_test_suite in db. Proceed only if it succeeds

            testsuite[:junit_test_suite_properties].each do |property| # Iterate through all the test_suite_properties
              junit_ts_prop = junit_ts.junit_test_suite_properties.new(property[:params])
              unless junit_ts_prop.save # Save junit_test_suite_property in db. Proceed only if it succeeds
                report.destroy # Destroy the report and all the associated models if something goes wrong
                render(failure_json) and return
              end
            end

            testsuite[:junit_test_cases].each do |testcase| # Iterate through all the test_cases
              junit_tc = junit_ts.junit_test_cases.new(testcase[:params])
              unless junit_tc.save
                report.destroy # Destroy the report and all the associated models if something goes wrong
                render(failure_json) and return
              end
            end

          else
            report.destroy # Destroy the report and all the associated models if something goes wrong
            render(failure_json) and return
          end
        end

      else
        report.destroy
        render(failure_json) and return
      end

      render(success_json)
    rescue Exception => e
      report.destroy # Destroy the report and all the associated models
      render(failure_json) and return
    end
  end
end
