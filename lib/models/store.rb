require 'pry'
class Store < ActiveRecord::Base
  has_many :store_products
  has_many :products, through: :store_products
  has_many :purchases
  # update
  has_many :customers, through: :purchases
  # update

  def self.categories
    Product.pluck(:category).uniq
  end

  def self.aggregate_revenue
    Product.joins(:purchases).sum(:price)
  end
  # update

  def revenue
      Product.joins(:purchases).where(purchases: {store_id: self.id}).sum(:price)
      # update
      # Product.joins("SELECT SUM(products.price)
      # FROM products
      # INNER JOIN store_products
      # ON store_products.product_id = products.id
      # INNER JOIN purchases
      # ON purchases.product_id = products.id
      # WHERE store_products.store_id = ?", self.id)
  end

  def local_customer_emails
    self.customers.pluck(:email)
  end

  def most_valued_customers
    top_five_array = Product.joins(:purchases).where(purchases: {store_id: self.id}).group(:customer_id).order("SUM(price) DESC").limit(5).pluck(:customer_id)
    puts Customer.find(top_five_array).pluck(:name)
    # update
  end

end
