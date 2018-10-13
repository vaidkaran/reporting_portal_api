class TestngResult < ApplicationRecord
  belongs_to :report
  has_many :testng_suites, dependent: :destroy
end
