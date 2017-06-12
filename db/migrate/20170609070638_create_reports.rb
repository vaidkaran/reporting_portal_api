class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :test_category_id
      t.string :type
      t.string :format

      t.timestamps
    end
  end
end
