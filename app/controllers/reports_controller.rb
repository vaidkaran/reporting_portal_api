class ReportsController < ApplicationController
  before_action :authenticate_user!

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
    if report._type == 'junit'
      return {json: report,
        include: {junit_test_suite_group:
        {include: {junit_test_suites:
        {include: [:junit_test_suite_properties, :junit_test_cases]}
        }}}}
    elsif report._type == 'mocha'
      return {json: report, include: [:mocha_stat, :mocha_tests, :mocha_passes, :mocha_failures]}
    else
      return nil
    end
  end

  def all_reports_json(test_category)
    return {json: test_category.reports}
  end
end
