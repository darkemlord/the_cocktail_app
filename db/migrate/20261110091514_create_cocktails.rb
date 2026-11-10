class CreateCocktails < ActiveRecord::Migration[8.1]
  def change
    create_table :cocktails do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :ingredients, null: false
      t.text :instructions, null: false
      t.integer :difficulty, null: false, default: 0

      t.timestamps
    end
  end
end
