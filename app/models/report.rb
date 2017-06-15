class Report < ApplicationRecord
  belongs_to :test_category
  has_one :junit_test_suite_group, dependent: :destroy

  has_one :mocha_stat
  has_many :mocha_tests
  has_many :mocha_passes
  has_many :mocha_failures
end
