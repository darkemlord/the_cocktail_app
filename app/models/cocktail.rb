class Cocktail < ApplicationRecord
  belongs_to :user

  enum :difficulty, { easy: 0, medium: 1, hard: 2 }

  validates :name, :ingredients, :instructions, presence: true
end
