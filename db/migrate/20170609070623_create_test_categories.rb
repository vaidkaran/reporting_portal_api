class CreateTestCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :test_categories do |t|
      t.integer :project_id
      t.string :name

      t.timestamps
    end
  end
end
