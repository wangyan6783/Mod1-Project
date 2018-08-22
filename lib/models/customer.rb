class Customer < ActiveRecord::Base
  has_many :purchases
  has_many :products, through: :purchases
  has_many :stores, through: :products
end
