class Organisation < ApplicationRecord
  has_many :projects
  has_many :org_users
end
