class RenameOrganisationalUsersToOrgUsers < ActiveRecord::Migration[5.0]
  def change
    rename_table :organisational_users, :org_users
  end
end
