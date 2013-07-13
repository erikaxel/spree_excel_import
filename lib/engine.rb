module SpreeExcelImport
  class Engine < Rails::Railtie
    engine_name :spree_excel_import

    rake_tasks do
      load "lib/tasks/spree_excel_import_tasks.rake"
    end

  end
end