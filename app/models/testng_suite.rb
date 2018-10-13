class TestngSuite < ApplicationRecord
  belongs_to :testng_result
  has_many :testng_groups, dependent: :destroy
  has_many :testng_tests, dependent: :destroy
end
