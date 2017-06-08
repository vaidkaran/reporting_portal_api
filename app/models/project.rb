class Project < ApplicationRecord
  belongs_to :users, optional: true
  belongs_to :organisation, optional: true
  has_and_belongs_to_many :organisational_users
end
