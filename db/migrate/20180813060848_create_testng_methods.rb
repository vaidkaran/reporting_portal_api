class CreateTestngMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_methods do |t|
      t.string :testng_group_id
      t.string :signature
      t.string :name
      t.string :_class

      t.timestamps
    end
  end
end
