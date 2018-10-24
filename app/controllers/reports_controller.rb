class ReportsController < ApplicationController

  def index
    test_category = TestCategory.find(params[:test_category_id])
    project = test_category.project

    if current_user and current_user==project.user
      render all_reports_json(test_category) and return
    elsif current_org_user
      if current_org_user.admin and current_org_user.organisation==project.organisation
        render all_reports_json(test_category) and return
      elsif current_org_user==project.org_user
        render all_reports_json(test_category) and return
      end
    else
      render unauthorized_json and return
    end
  end

  def show
    report = Report.find params[:id]
    project = report.test_category.project

    if current_user and current_user==project.user
      render report_json(report) and return
    elsif current_org_user
      if current_org_user.admin and current_org_user.organisation==project.organisation
        render report_json(report) and return
      elsif current_org_user==project.org_user
        render report_json(report) and return
      end
    else
      render unauthorized_json and return
    end
  end

  private
  def report_json(report)
    # TODO: Make the code simpler and easy to understand
    if report.test_category.report_type == 'junit'
      return {json: report,
        include: {junit_test_suite_group:
        {include: {junit_test_suites:
        {include: [:junit_test_suite_properties, :junit_test_cases]}
        }}}}
    elsif report.test_category.report_type == 'testng'
      #require 'pry'; binding.pry
      return {json: report,
              include: {testng_result:
                       {include: {testng_suites:
                                 {include: [{testng_groups:
                                            {include: :testng_methods}},
                                            {testng_tests:
                                            {include: {testng_classes:
                                            {include: {testng_test_methods:
                                            {include: [:testng_test_method_exception, :testng_test_method_params]}}}}}}]}}}}}
    elsif report.test_category.report_type == 'mocha'
      return {json: report, include: [:mocha_stat, :mocha_tests, :mocha_passes, :mocha_failures]}
    else
      return nil
    end
  end

  def all_reports_json(test_category)
    return {json: test_category.reports}
  end

  def unauthorized_json
    {json: {"errors":["You need to sign in or sign up before continuing."]}, code: 401}
  end
end
