module CocktailsHelper
  # Cover art: the five city pop tones, each with its glass
  TONES = {
    1 => { n: 1, tag: "サンセット",   glass: "rocks" },
    2 => { n: 2, tag: "プールサイド", glass: "highball" },
    3 => { n: 3, tag: "ミッドナイト", glass: "fizz" },
    4 => { n: 4, tag: "トワイライト", glass: "coupe" },
    5 => { n: 5, tag: "ネオン",       glass: "margarita" }
  }.freeze

  # Which tone fits each mood
  MOOD_TONES = {
    after_hours: 1, golden_sunset: 2, summer_night: 2, tokyo_rain: 3,
    heartbreak: 3, midnight_romance: 4, sweet_memories: 4, neon_dreams: 5
  }.freeze

  def cocktail_tone(cocktail)
    TONES.fetch(MOOD_TONES.fetch(cocktail.mood.to_sym))
  end

  def mood_options
    Cocktail.moods.keys.map { |mood| [ mood.titleize, mood ] }
  end

  def ingredient_lines(cocktail)
    cocktail.ingredients.lines.map(&:strip).compact_blank
  end
end
