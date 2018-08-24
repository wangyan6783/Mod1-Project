require_relative '../config/environment'
require 'pry'
require 'artii'

puts "************************************************************"
logo = Artii::Base.new
puts logo.asciify("YAN - FOR")
puts "************************************************************"


welcome_message
directory
input = gets_user_input_index
navigator(input)
