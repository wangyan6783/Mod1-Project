require 'colorize'

def welcome_message
  # puts "**********************************".blink
  puts ""
  puts "WELCOME TO YAN-FOR SALES DATABASE".on_light_green
  puts ""
  # puts "**********************************".blink
end

def gets_user_input_index
  puts "Please select the option number (example: 1)".white.on_light_blue
  input = gets.chomp
end

def directory
  puts ""
  puts "***************".blink.green
  puts "Main Directory:".blue
  puts "***************".blink.green
  puts ""
  puts "1. Global Data".underline
  puts ""
  puts "2. Local Data".underline
  puts ""
  puts "3. Create Product".underline
  puts ""
  puts "4. Update Product".underline
  puts ""
  puts "5. Manual Order Entry".underline
  puts ""
  puts "6. Exit".underline
  puts ""
end

def navigator(input)
  case input
  when '1'
    # direct to global data
    # global_directory
    # input = gets_user_input_index
    global_navigator
  when '2'
    # direct to local data
    puts ""
    puts "************".blink.green
    puts "Local Data:".blue
    puts "************".blink.green
    puts ""
    local_store_listings
    input_location = gets.chomp
    store_instance = local_store_search(input_location)
    local_navigator(store_instance)
  when '3'
    create_product
    load 'bin/run.rb'
  when '4'
    update_product
    load 'bin/run.rb'
  when '5'
    create_order
    load 'bin/run.rb'
  when '6'
    abort
  end

end

def global_directory
  puts ""
  puts "************".blink.green
  puts "Global Data:".blue
  puts "************".blink.green
  puts ""
  puts "1. Total Revenue All Stores".underline
  puts ""
  puts "2. Transaction Volume by Card Type".underline
  puts ""
  puts "3. Global Products".underline
  puts ""
  puts "4. In-Season Items".underline
  puts ""
  puts "5. List Product by Category".underline # enter category -> products and in-season
  puts ""
  puts "6. Best Selling Items".underline
  puts ""
  puts "7. Highest Grossing Item".underline
  puts ""
  puts "8. Customers on Record".underline
  puts ""
  puts "9. VIP Customers".underline
  puts ""
  puts "10. Go to Local Data".underline
  puts ""
  puts "11. Exit".underline
  puts ""
end

def global_navigator
  global_directory
  input = gets_user_input_index
  case input
  when '1'
    puts ""
    puts "=========================".green
    puts Store.aggregate_revenue
    puts "=========================".green
    puts ""
  when '2'
    puts ""
    puts "=========================".green
    Purchase.card_usage
    puts "=========================".green
    puts ""
  when '3'
    puts ""
    puts "=========================".green
    puts Product.pluck(:name)
    puts "=========================".green
    puts ""
  when '4'
    puts ""
    puts "=========================".green
    puts Product.where(in_season: true).pluck(:name)
    puts "=========================".green
    puts ""
  when '5'
    Product.products_by_category
  when '6'
    puts ""
    puts "=========================".green
    puts Product.best_selling
    puts "=========================".green
    puts ""
  when '7'
    puts ""
    puts "=========================".green
    puts Product.highest_gross_product
    puts "=========================".green
    puts ""
  when '8'
    puts ""
    puts "=========================".green
    Customer.all_data
    puts "=========================".green
    puts ""
  when '9'
    puts ""
    puts "=========================".green
    Customer.most_valued_customers
    puts "=========================".green
    puts ""
  when '10'
    navigator('2')
  when '11'
    abort
  end

  puts "Return to list? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    global_navigator
  else
    load 'bin/run.rb'
  end
end

def local_store_listings
  puts "Enter Country from List into Console. Please enter number:".white.on_light_blue
  Store.pluck(:location).each_with_index do |country,index|
      puts "#{index + 1}. #{country}"
      end
end

def local_store_info
  puts ""
  puts "************".blink.green
  puts "Local Data:".blue
  puts "************".blink.green
  puts ""
  puts "1. Store Revenue".underline
  puts ""
  puts "2. Products".underline
  puts ""
  puts "3. Customers on Record".underline
  puts ""
  puts "4. Customer Emails".underline
  puts ""
  puts "5. VIP Customers".underline
  puts ""
  puts "6. Return to Global Data".underline
  puts ""
  puts "7. Exit".underline
  puts ""
end

def local_navigator(store)
  local_store_info
  info_selection = gets_user_input_index

  case info_selection
  when '1'
    puts ""
    puts "=========================".green
    puts store.revenue
    puts "=========================".green
    puts ""
  when '2'
    puts ""
    puts "=========================".green
    puts store.products.pluck(:name)
    puts "=========================".green
    puts ""
  when '3'
    puts ""
    puts "=========================".green
    puts store.customers.distinct.pluck(:name)
    puts "=========================".green
    puts ""
  when '4'
    puts ""
    puts "=========================".green
    puts store.local_customer_emails
    puts "=========================".green
    puts ""
  when '5'
    puts ""
    puts "=========================".green
    puts store.most_valued_customers
    puts "=========================".green
    puts ""
  when '6'
    navigator('1')
  when '7'
    abort
  end

  puts "Return to list? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    local_navigator(store)
  else
    load 'bin/run.rb'
  end
end


def local_store_search(input_location)
  return_value = Store.find(input_location.to_i)
  if return_value == nil
    puts "Invalid Entry."
  end
  return_value
end


def create_product #store method
  puts ""
  puts "***************".blink.green
  puts "Create Product:".blue
  puts "***************".blink.green
  puts ""
  puts "Enter a name for the product:".white.on_light_blue
    name = gets.chomp
  puts "Enter a category for the product:".white.on_light_blue
    category = gets.chomp
  puts "Enter a price for the product:".white.on_light_blue
    price = gets.chomp.to_i
  puts "In Season? (true/false)".white.on_light_blue
    in_season = gets.chomp


  new_product = Product.create(name: name, category: category, price: price, in_season: in_season)
  i = 0
  while i < Store.all.length do
    StoreProduct.create(store_id: (i+1), product_id: new_product.id)
    i += 1
  end
  puts ""
  puts "Product Created:".white.on_red
  puts ""
  puts "================================".green
  puts "#{new_product.name} - #{new_product.category} - #{new_product.price} - #{new_product.in_season}"
  puts "================================".green
  puts ""
  puts "Return to list? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    load 'bin/run.rb'
  else
    abort
  end
end


def all_products
  Product.all.each do |product|
      puts "#{product.name}, Current Price: #{product.price}, Ref. No. #{product.id}"
      end
end
# update - move to Product Class

def update_product
  puts ""
  puts "***************".blink.green
  puts "Update Product:".blue
  puts "***************".blink.green
  puts ""
  all_products
  puts "Enter Product from List into Console.".white.on_light_blue
  puts ""
  puts "Please use reference number:".white.on_light_blue
  ref_num = gets.chomp
  product = Product.find(ref_num)
  puts "Update price? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    puts "Enter new price:".white.on_light_blue
    new_price = gets.chomp
    product.update(price: new_price)
  end

  puts "Update in-season status? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    puts "Enter in-season status (true/false)".white.on_light_blue
    new_status = gets.chomp
    product.update(in_season: new_status)
  end

  puts ""
  puts "Product Updated:".white.on_red
  puts ""
  puts "================================".green
  puts "#{product.name} - #{product.category} - #{product.price} - #{product.in_season}"
  puts "================================".green
  puts ""
  puts "Return to list? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    load 'bin/run.rb'
  else
    abort
  end

end

def all_stores
  Store.all.each do |store|
    puts "#{store.location}, Ref. No. #{store.id}"
  end
end
# update

def create_order
  puts ""
  puts "*******************".blink.green
  puts "Manual Order Entry:".blue
  puts "*******************".blink.green
  puts ""
  puts "Enter customer email:".white.on_light_blue
  email = gets.chomp
  if Customer.find_by(email: email)
    customer_id = Customer.find_by(email: email).id
    puts "Found existing customer record.".white.on_light_blue
  else
    puts ""
    puts "No such customer registered in our records.".white.on_red
    puts ""
    puts "Please enter the customer's full name:".white.on_light_blue
    full_name = gets.chomp
    customer_id = Customer.create(name: full_name, email: email).id
  end
  puts "======================"
  puts "Currently Available:".white.on_light_blue
  all_products
  puts "Please enter the Product Ref. No.:".white.on_light_blue
  prod_id = gets.chomp
  puts "Please Enter Card Name/Type (example: Visa):".white.on_light_blue
  puts "1. Visa"
  puts "2. MasterCard"
  puts "3. Discover"
  puts "4. Debit"
  card_type = gets.chomp
  puts ""
  all_stores
  puts "Please Enter the Store Ref. No.:".white.on_light_blue
  store_id = gets.chomp
  # update

  Purchase.create(customer_id: customer_id, product_id: prod_id, store_id: store_id, card_type: card_type)
  puts ""
  puts "Order Submitted.".white.on_red
  puts ""
  puts "Return to list? (y/n)".white.on_light_blue
  response = gets.chomp
  if response == 'y'
    load 'bin/run.rb'
  else
    abort
  end

end
