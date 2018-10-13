class TestngTestMethod < ApplicationRecord
  belongs_to :testng_class
  has_many :testng_test_method_params, dependent: :destroy
  has_one :testng_test_method_exception, dependent: :destroy
end
