class TestngClass < ApplicationRecord
  belongs_to :testng_test
  has_many :testng_test_methods, dependent: :destroy
end
