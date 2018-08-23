class Product < ActiveRecord::Base
  has_many :store_products
  has_many :stores, through: :store_products
  has_many :purchases
  has_many :customers, through: :purchases

  def purchasers_emails
    self.customers.pluck(:email)
  end

  def self.best_selling
    joins(:purchases).group(:product_id).order('COUNT(*) DESC').limit(1).pluck(:name)
  end

  def self.highest_gross_product
    Product.joins(:purchases).group(:product_id).order("SUM(price) DESC").limit(1).pluck(:name)
  end

  def self.products_by_category
    puts "Please select category by name (example: Outerwear)"
    puts Product.pluck(:category).uniq
    puts "Input text here:"
    input = gets.chomp
    prod_array = Product.where(category: input)
    if prod_array == []
      puts "Invalid Input"
    else
      prod_array.each do |product|
        puts "#{product.name} - $#{product.price} - in-season: #{product.in_season}"
      end
    end
  end


end
