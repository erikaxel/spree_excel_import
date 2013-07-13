module SpreeExcelImport
  class Engine < Rails::Railtie
    engine_name :spree_excel_import

    rake_tasks do
      load "spree_excel_import/railities/spree_excel_import_tasks.rake"
    end

  end
end