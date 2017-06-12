class JunitTestSuite < ApplicationRecord
  belongs_to :junit_test_suite_group
  has_many :junit_test_suite_properties, dependent: :destroy
  has_many :junit_test_cases, dependent: :destroy
end
