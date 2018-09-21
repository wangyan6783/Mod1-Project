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
    puts ""
    puts "=========================".green
    puts Product.pluck(:category).uniq
    puts "=========================".green
    puts ""
    puts "Please select category by name (example: Outerwear)".white.on_light_blue
    puts ""
    puts "Input text here:".white.on_light_blue
    input = gets.chomp
    prod_array = Product.where(category: input)
    if prod_array == []
      puts "Invalid Input".white.on_red
      puts ""
    else
      puts ""
      puts "============================================".green
      prod_array.each do |product|
        puts "#{product.name} - $#{product.price} - in-season: #{product.in_season}"
      end
      puts "============================================".green
      puts ""
    end
  end

  def self.all_products
    self.all.map do |product|
      puts "#{product.name}, Current Price: #{product.price}, In Season? #{product.in_season}, Ref. No. #{product.id}"
    end
    nil
  end

  def self.in_season_products
    self.where(in_season: true).each do |product|
      puts "#{product.name}, Current Price: #{product.price}, Ref. No. #{product.id}"
    end
  end
end
