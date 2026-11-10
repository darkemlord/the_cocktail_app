module CocktailsHelper
  # Cover art for each cocktail: rotates through the five city pop tones
  TONES = [
    { n: 1, tag: "サンセット",   glass: "rocks" },
    { n: 2, tag: "プールサイド", glass: "highball" },
    { n: 3, tag: "ミッドナイト", glass: "fizz" },
    { n: 4, tag: "トワイライト", glass: "coupe" },
    { n: 5, tag: "ネオン",       glass: "margarita" }
  ].freeze

  def cocktail_tone(cocktail)
    TONES[cocktail.id % TONES.size]
  end

  def ingredient_lines(cocktail)
    cocktail.ingredients.lines.map(&:strip).compact_blank
  end
end
