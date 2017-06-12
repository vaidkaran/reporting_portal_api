class CreateJunitTestSuites < ActiveRecord::Migration[5.0]
  def change
    create_table :junit_test_suites do |t|
      t.integer :junit_test_suite_group_id
      t.string :name
      t.integer :tests
      t.integer :disabled
      t.integer :_errors
      t.integer :failures
      t.string :hostname
      t.integer :testsuiteid
      t.string :package
      t.integer :skipped
      t.integer :time
      t.string :timestamp
      t.text :system_out
      t.text :system_err

      t.timestamps
    end
  end
end
