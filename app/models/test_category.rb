class TestCategory < ApplicationRecord
  belongs_to :project
  has_many :reports, dependent: :destroy
end
