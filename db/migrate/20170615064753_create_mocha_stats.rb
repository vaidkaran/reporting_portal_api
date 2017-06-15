class CreateMochaStats < ActiveRecord::Migration[5.0]
  def change
    create_table :mocha_stats do |t|
      t.integer :report_id
      t.integer :suites
      t.integer :tests
      t.integer :passes
      t.integer :failures
      t.string :start
      t.string :end
      t.integer :duration

      t.timestamps
    end
  end
end
