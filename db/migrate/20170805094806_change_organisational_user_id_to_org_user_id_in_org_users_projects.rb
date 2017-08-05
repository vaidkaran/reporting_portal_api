class ChangeOrganisationalUserIdToOrgUserIdInOrgUsersProjects < ActiveRecord::Migration[5.0]
  def change
    rename_column :org_users_projects, :organisational_user_id, :org_user_id
  end
end
