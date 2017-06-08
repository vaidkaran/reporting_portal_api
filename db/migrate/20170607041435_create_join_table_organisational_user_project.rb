class CreateJoinTableOrganisationalUserProject < ActiveRecord::Migration[5.0]
  def change
    create_join_table :organisational_users, :projects do |t|
      # t.index [:organisational_user_id, :project_id]
      # t.index [:project_id, :organisational_user_id]
    end
  end
end
