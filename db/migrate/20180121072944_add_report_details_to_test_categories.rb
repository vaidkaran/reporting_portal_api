class AddReportDetailsToTestCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :test_categories, :report_type, :string
    add_column :test_categories, :report_format, :string

    remove_column :reports, :_type, :string
    remove_column :reports, :format, :string
  end
end
