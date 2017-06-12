class FixTypeColumnConflicts < ActiveRecord::Migration[5.0]
  def change
    rename_column :reports, :type, :_type
  end
end
