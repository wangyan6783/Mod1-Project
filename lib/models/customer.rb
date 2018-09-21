require 'pry'
class Customer < ActiveRecord::Base
  validates :email, presence: true
  has_many :purchases
  has_many :products, through: :purchases
  has_many :stores, through: :purchases

  def self.most_valued_customers
    top_five_array = Product.joins(:purchases).group(:customer_id).order("SUM(price) DESC").limit(5).pluck(:customer_id)
    puts self.find(top_five_array).pluck(:name)
  end

  def self.all_data
    Customer.all.collect do |customer|
      puts "#{customer.name} <#{customer.email}>"
    end
  end
end
