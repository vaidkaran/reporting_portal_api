class Organisation < ApplicationRecord
  has_many :projects
  has_many :organisational_users
end
