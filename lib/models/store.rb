require 'pry'
class Store < ActiveRecord::Base
  has_many :store_products
  has_many :products, through: :store_products
  has_many :purchases
  has_many :customers, through: :purchases

  def self.all_stores
    self.all.each do |store|
      puts "#{store.location}, Ref. No. #{store.id}"
    end
  end

  def self.categories
    Product.pluck(:category).uniq
  end

  def self.aggregate_revenue
    Product.joins(:purchases).sum(:price)
  end

  def revenue
      Product.joins(:purchases).where(purchases: {store_id: self.id}).sum(:price)
  end

  def local_customer_emails
    self.customers.pluck(:email)
  end

  def most_valued_customers
    top_five_array = Product.joins(:purchases).where(purchases: {store_id: self.id}).group(:customer_id).order("SUM(price) DESC").limit(5).pluck(:customer_id)
    puts Customer.find(top_five_array).pluck(:name)
  end

end
