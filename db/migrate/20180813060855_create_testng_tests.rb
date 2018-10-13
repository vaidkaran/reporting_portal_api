class CreateTestngTests < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_tests do |t|
      t.integer :testng_suite_id
      t.string :name
      t.integer :duration_ms
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
