class Report < ApplicationRecord
  belongs_to :test_category
  has_one :junit_test_suite_group, dependent: :destroy

  has_one :testng_result, dependent: :destroy

  has_one :mocha_stat, dependent: :destroy
  has_many :mocha_tests, dependent: :destroy
  has_many :mocha_passes, dependent: :destroy
  has_many :mocha_failures, dependent: :destroy
end
