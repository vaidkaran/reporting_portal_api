class ChangeTitleTypeInMocha < ActiveRecord::Migration[5.0]
  def change
    change_column :mocha_tests, :title, :text
    change_column :mocha_tests, :fullTitle, :text

    change_column :mocha_passes, :title, :text
    change_column :mocha_passes, :fullTitle, :text

    change_column :mocha_failures, :title, :text
    change_column :mocha_failures, :fullTitle, :text
  end
end
