class JunitTestSuiteGroup < ApplicationRecord
  belongs_to :report
  has_many :junit_test_suites, dependent: :destroy
end
