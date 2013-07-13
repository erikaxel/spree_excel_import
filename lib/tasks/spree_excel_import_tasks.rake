namespace :db do
  task :import_products => :environment do
    desc "import products from products.xlsx"
    SpreeExcelImport::DataImport.import_windows 'products.xlsx'
  end
end