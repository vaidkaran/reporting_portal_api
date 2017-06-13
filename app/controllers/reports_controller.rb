class ReportsController < ApplicationController
  before_action :authenticate_user!

  def show
    report = Report.find params[:id]

    render json: report,
      include: {junit_test_suite_group:
      {include: {junit_test_suites:
      {include: [:junit_test_suite_properties, :junit_test_cases]}
      }}}
  end
end
