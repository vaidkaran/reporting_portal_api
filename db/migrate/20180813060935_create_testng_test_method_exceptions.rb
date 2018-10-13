class CreateTestngTestMethodExceptions < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_test_method_exceptions do |t|
      t.integer :testng_test_method_id
      t.string :_class
      t.text :message
      t.text :full_stacktrace

      t.timestamps
    end
  end
end
