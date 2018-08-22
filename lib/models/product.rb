class Product < ActiveRecord::Base
  has_many :store_products
  has_many :stores, through: :store_products
  has_many :purchases
  has_many :customers, through: :purchases

  def purchasers_emails
    self.customers.pluck(:email)
  end

  def self.best_selling
    joins(:purchases).group(:product_id).order('COUNT(*) DESC').limit(1)
  end

  def self.highest_gross_product
    Product.joins(:purchases).group(:product_id).order("SUM(price) DESC").limit(1).pluck(:name)
  end


end
