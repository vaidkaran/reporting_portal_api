class CreateTestngGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_groups do |t|
      t.integer :testng_suite_id
      t.string :name

      t.timestamps
    end
  end
end
