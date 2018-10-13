class CreateTestngTestMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_test_methods do |t|
      t.integer :testng_class_id
      t.boolean :status
      t.string :signature
      t.string :test_instance_name
      t.string :name
      t.boolean :is_config
      t.integer :duration_ms
      t.datetime :started_at
      t.datetime :finished_at
      t.text :data_provider
      t.text :description
      t.text :reporter_output

      t.timestamps
    end
  end
end
