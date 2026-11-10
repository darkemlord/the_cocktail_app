class AddMoodToCocktails < ActiveRecord::Migration[8.1]
  def change
    add_column :cocktails, :mood, :integer, null: false, default: 0
    add_index :cocktails, :mood
  end
end
