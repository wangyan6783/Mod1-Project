class Store < ActiveRecord::Base
  has_many :store_products
  has_many :products, through: :store_products
  has_many :purchases, through: :products
  has_many :customers, through: :products
end
