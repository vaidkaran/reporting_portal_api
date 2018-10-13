class CreateTestngTestMethodParams < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_test_method_params do |t|
      t.integer :testng_test_method_id
      t.integer :index
      t.text :value

      t.timestamps
    end
  end
end
