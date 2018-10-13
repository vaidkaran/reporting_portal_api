class CreateTestngResults < ActiveRecord::Migration[5.1]
  def change
    create_table :testng_results do |t|
      t.integer :report_id
      t.integer :skipped
      t.integer :failed
      t.integer :ignored
      t.integer :passed
      t.text :reporter_output

      t.timestamps
    end
  end
end
