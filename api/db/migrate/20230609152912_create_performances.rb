class CreatePerformances < ActiveRecord::Migration[6.0]
  def change
    create_table :performances do |t|
      t.integer :sales, null: false
      t.integer :profits, null: false
      t.string :year, null: false
      t.references :firm, null: false, foreign_key: true
      t.timestamps
    end
  end
end
