class CreateJunitTestSuiteProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :junit_test_suite_properties do |t|
      t.integer :junit_test_suite_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
