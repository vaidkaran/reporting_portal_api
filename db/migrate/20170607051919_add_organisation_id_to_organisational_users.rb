class AddOrganisationIdToOrganisationalUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :organisational_users, :organisation_id, :integer
  end
end
