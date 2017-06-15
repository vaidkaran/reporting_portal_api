class ReportsController < ApplicationController
  before_action :authenticate_user!

  def show
    report = Report.find params[:id]

    if report._type == 'junit'
      render json: report,
        include: {junit_test_suite_group:
        {include: {junit_test_suites:
        {include: [:junit_test_suite_properties, :junit_test_cases]}
        }}}
    elsif report._type == 'mocha'
      render json: report, include: [:mocha_stat, :mocha_tests, :mocha_passes, :mocha_failures]
    end
  end
end
