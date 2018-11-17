class UploadController < ApplicationController
  include UploadHelper
  before_action :ensure_authenticated
  before_action -> { return if save_report.nil? }

  def mocha
    begin
      file = File.read params[:upload].tempfile
      report_data = JSON.parse(file) # report_data is a Hash

      mocha_stat_params = report_data['stats']
      mocha_test_params_array = report_data['tests']
      mocha_pass_params_array = report_data['passes']
      mocha_failure_params_array = report_data['failures']

      mocha_stat = @report.build_mocha_stat(mocha_stat_params)
      unless mocha_stat.save
        @report.destroy # Destroy the report and all the associated models if something goes wrong
        render(failure_json) and return
      end

      mocha_test_params_array.each do |mocha_test_params|
        mocha_test = @report.mocha_tests.new(mocha_test_params)
        unless mocha_test.save
          @report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end
      end

      mocha_pass_params_array.each do |mocha_pass_params|
        mocha_pass = @report.mocha_passes.new(mocha_pass_params)
        unless mocha_pass.save
          @report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end
      end

      mocha_failure_params_array.each do |mocha_failure_params|
        mocha_failure = @report.mocha_failures.new(mocha_failure_params)
        unless mocha_failure.save
          @report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end
      end

      render(success_json)
    rescue Exception=>e
      @report.destroy # Destroy the report and all the associated models
      render(failure_json) and return
    end
  end

  def junit
    # flag to make sure tsg is created only once even for multiple files
    @create_junit_tsg = true
    failure_flag = false

    params[:upload].each do |upload_param|
      if !write_junit_report_to_db(upload_param.tempfile)
        failure_flag = true
        break
      end
    end

    unless failure_flag
      render(success_json)
    end
  end

  def testng
    begin
      file = params[:upload].tempfile
      report_data = parse_testng_xml(file)

      testng_result = @report.build_testng_result(report_data[:testng_results][:params])
      unless testng_result.save
        @report.destroy # Destroy the report and all the associated models if something goes wrong
        render(failure_json) and return
      end

      report_data[:testng_results][:testng_suites].each do |suite|
        testng_suite = testng_result.testng_suites.build(suite[:params])
        unless testng_suite.save
          @report.destroy # Destroy the report and all the associated models if something goes wrong
          render(failure_json) and return
        end

        suite[:testng_groups].each do |group|
          testng_group = testng_suite.testng_groups.build(group[:params])
          unless testng_group.save
            @report.destroy # Destroy the report and all the associated models if something goes wrong
            render(failure_json) and return
          end

          group[:testng_methods].each do |method|
            testng_method = testng_group.testng_methods.build(method[:params])
            unless testng_method.save
              @report.destroy # Destroy the report and all the associated models if something goes wrong
              render(failure_json) and return
            end
          end
        end

        suite[:testng_tests].each do |test|
          testng_test = testng_suite.testng_tests.build(test[:params])
          unless testng_test.save
            @report.destroy # Destroy the report and all the associated models if something goes wrong
            render(failure_json) and return
          end

          test[:testng_classes].each do |_class|
            testng_class = testng_test.testng_classes.build(_class[:params])
            unless testng_class.save
              @report.destroy # Destroy the report and all the associated models if something goes wrong
              render(failure_json) and return
            end

            _class[:testng_test_methods].each do |test_method|
              testng_test_method = testng_class.testng_test_methods.build(test_method[:params])
              unless testng_test_method.save
                @report.destroy # Destroy the report and all the associated models if something goes wrong
                render(failure_json) and return
              end

              test_method[:testng_test_method_params].each do |test_method_param|
                testng_test_method_param = testng_test_method.testng_test_method_params.build(test_method_param[:params])
                unless testng_test_method_param.save
                  @report.destroy # Destroy the report and all the associated models if something goes wrong
                  render(failure_json) and return
                end
              end

              if test_method[:testng_test_method_exception]
                testng_test_method_exception = testng_test_method
                  .build_testng_test_method_exception(test_method[:testng_test_method_exception][:params])
                unless testng_test_method_exception.save
                  @report.destroy # Destroy the report and all the associated models if something goes wrong
                  render(failure_json) and return
                end
              end

            end
          end
        end
      end
      render(success_json)
    rescue Exception => e
      @report.destroy # Destroy the report and all the associated models
      render(failure_json) and return
    end

  end
end


