class CreateJunitTestSuiteGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :junit_test_suite_groups do |t|
      t.integer :report_id
      t.string :name
      t.integer :_errors
      t.integer :tests
      t.integer :failures
      t.integer :time

      t.timestamps
    end
  end
end
