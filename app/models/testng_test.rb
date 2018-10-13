class TestngTest < ApplicationRecord
  belongs_to :testng_suite
  has_many :testng_classes, dependent: :destroy
end
