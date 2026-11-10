class Cocktail < ApplicationRecord
  belongs_to :user

  enum :difficulty, { easy: 0, medium: 1, hard: 2 }, validate: true
  # The moods from "Cocktails by Mood" in the README
  enum :mood, {
    after_hours: 0, midnight_romance: 1, tokyo_rain: 2, heartbreak: 3,
    summer_night: 4, golden_sunset: 5, sweet_memories: 6, neon_dreams: 7
  }, validate: true

  validates :name, :ingredients, :instructions, presence: true
end
