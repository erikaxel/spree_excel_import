module SpreeExcelImport
  class Engine < Rails::Engine
    engine_name :spree_excel_import

    rake_tasks do
      load "tasks/spree_excel_import_tasks.rake"
    end

  end
end