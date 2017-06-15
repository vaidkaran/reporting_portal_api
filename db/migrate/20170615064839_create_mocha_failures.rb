class CreateMochaFailures < ActiveRecord::Migration[5.0]
  def change
    create_table :mocha_failures do |t|
      t.integer :report_id
      t.string :title
      t.string :full_title
      t.integer :duration

      t.timestamps
    end
  end
end
