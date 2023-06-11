class CreateFirms < ActiveRecord::Migration[6.0]
  def change
    create_table :firms do |t|
      t.string :code, null: false
      t.integer :status, null: false
      t.string :firm_name, null: false
      t.string :firm_name_kana, null: false
      t.string :post_code, null: false
      t.string :address, null: false
      t.string :representive, null: false
      t.string :representive_kana, null: false
      t.string :phone_number, null: false
      t.timestamps
    end
  end
end
