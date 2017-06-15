class ChangeFullTitleToCamelcase < ActiveRecord::Migration[5.0]
  def change
    rename_column :mocha_tests, :full_title, :fullTitle
    rename_column :mocha_failures, :full_title, :fullTitle
    rename_column :mocha_passes, :full_title, :fullTitle
  end
end
