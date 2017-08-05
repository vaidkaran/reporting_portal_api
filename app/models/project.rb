class Project < ApplicationRecord
  validates :name, presence: true

  belongs_to :users, optional: true
  belongs_to :organisation, optional: true
  has_and_belongs_to_many :org_users
  has_many :test_categories, dependent: :destroy
end
