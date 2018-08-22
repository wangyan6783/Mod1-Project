class Product < ActiveRecord::Base
  has_many :store_products
  has_many :stores, through: :store_products
  has_many :purchases
  has_many :customers, through: :purchases
end
