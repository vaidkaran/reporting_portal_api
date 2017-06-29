class AddAdminToOrganisationalUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :organisational_users, :admin, :boolean
  end
end
