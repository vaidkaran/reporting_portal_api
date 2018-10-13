class CreateTestngClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_classes do |t|
      t.integer :testng_test_id
      t.string :name

      t.timestamps
    end
  end
end
