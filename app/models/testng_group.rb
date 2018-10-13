class TestngGroup < ApplicationRecord
  belongs_to :testng_suite
  has_many :testng_methods, dependent: :destroy
end
