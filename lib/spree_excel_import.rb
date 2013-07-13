# encoding: UTF-8
require 'roo'
require 'date'

module SpreeExcelImport
  class DataImport
    def self.import(filename)
      book = Roo::Excelx.new filename
      puts "Starting import of " + filename
      book.default_sheet = book.sheets.first
      import_products book
    end

    def self.import_products(book, taxon=nil)
      properties = Hash.new

      title_row = book.row(1)

      title_row.each_with_index { |str, index|
        arr = str.split(":")
        if arr[0] == "Property"
          properties[arr[1]] = index
        end
      }

      tax_category = Spree::TaxCategory.where("name = ?", "MVA").first
      valid_rows = 0
      puts "Found " + book.last_row.to_s + " rows in the table"
      2.upto(book.last_row) do |row_num|
        #2.upto(20) do |row_num| # to test
        row = book.row(row_num)
        if row[0] == "TRUE"
          product = create_or_update_product(row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], tax_category, taxon)
          properties.each { |key, value|
            add_or_update_property(product, key, row[value])
          }
          valid_rows += 1
        end
      end
      puts "Import successfully finished of " + valid_rows.to_s + " valid rows"
    end

    def self.add_or_update_property(product, name, value)
      # Because of excel conversion we would like to remove extra .0 added to floats
      value = value.to_i if value.is_a?(Numeric) && value.to_i == value
      property = Spree::Property.where("name = ?", name).first
      return if (!property)
      prop = Spree::ProductProperty.where("product_id = ? and property_id = ?", product, property).first
      prop = Spree::ProductProperty.new() unless prop
      prop.value = value
      prop.product = product
      prop.property = property
      prop.save
    end

    def self.create_or_update_product(sku, name, description, available_on, price, cost_price, count_on_hand, width, height, thickness, weight, tax_category, taxon)
      master = Spree::Variant.where("sku = ?", sku).first
      if master
        product = master.product
        #product.update_column(:count_on_hand, count_on_hand)
      else
        product = Spree::Product.new()

        product.sku = sku
        product.master = Spree::Variant.new(
            :sku => sku,
            :cost_currency => "NOK"
        )

        default_price = Spree::Price.new(
            :currency => "NOK"
        )
        product.master.default_price = default_price
      end

      if taxon != nil
        product.taxons.clear
        product.taxons << taxon
      end
      product.name = name
      product.tax_category = tax_category
      product.description = description
      product.available_on = available_on

      product.master.is_master = true
      #product.master.count_on_hand = count_on_hand
      product.master.cost_price= cost_price
      product.master.default_price.amount = price

      product.height = height
      product.width = width
      product.depth = thickness
      product.weight = weight

      product.save()
      product
    end

    def self.to_boolean(str)
      str == 'TRUE'
    end
  end
end
