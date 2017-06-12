class CreateJunitTestCases < ActiveRecord::Migration[5.0]
  def change
    create_table :junit_test_cases do |t|
      t.integer :junit_test_suite_id
      t.string :name
      t.integer :assertions
      t.string :classname
      t.string :status
      t.integer :time
      t.integer :skipped
      t.string :error_message
      t.string :error_type
      t.text :error_text
      t.string :failure_message
      t.string :failure_type
      t.text :failure_text
      t.text :system_out
      t.text :system_err

      t.timestamps
    end
  end
end
