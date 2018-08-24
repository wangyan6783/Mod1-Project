require 'pry'
class Purchase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :product
  belongs_to :store
  # update

  def self.card_usage
    data = Product.joins(:purchases).group(:card_type).order('SUM(price) DESC').pluck(:card_type, 'SUM(price)')
    data.each do |card|
      puts "#{card[0]}: #{card[1]}"
    end
  end
end
