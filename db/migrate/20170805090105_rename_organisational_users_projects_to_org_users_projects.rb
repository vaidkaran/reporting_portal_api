class RenameOrganisationalUsersProjectsToOrgUsersProjects < ActiveRecord::Migration[5.0]
  def change
    rename_table :organisational_users_projects, :org_users_projects
  end
end
