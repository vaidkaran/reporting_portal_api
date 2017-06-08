class OrganisationalUser < ActiveRecord::Base

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  belongs_to :organisation, optional: true
  has_and_belongs_to_many :projects
end
