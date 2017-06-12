class Report < ApplicationRecord
  belongs_to :test_category
  has_one :junit_test_suite_group, dependent: :destroy
end
