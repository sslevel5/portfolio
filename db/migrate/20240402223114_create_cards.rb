class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|

      t.string :title, null: false
      t.string :conversion_title
      t.text :body, null: false
      t.integer :price, null: false
      t.boolean :is_active, null: false, default: true
      t.integer :rarity_id, null: false
      t.integer :store_id, null: false
      t.integer :customer_id

      t.timestamps
    end
  end
end
