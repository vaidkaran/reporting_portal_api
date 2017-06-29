class AddDefaultValueAdminToOrgUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :org_users, :admin, :boolean, default: false
  end
end
