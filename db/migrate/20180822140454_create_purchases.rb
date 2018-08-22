class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.integer :customer_id
      t.integer :product_id
      t.string :card_type
      t.timestamps
    end
  end
end
