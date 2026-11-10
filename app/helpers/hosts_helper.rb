module HostsHelper
  # The hosts of the bar: anime characters who comment on each page
  HOSTS = {
    nagisa: { name: "Nagisa", role: "The Midnight Muse", jp: "ナギサ" },
    reina:  { name: "Reina",  role: "The Bartender",     jp: "レイナ" },
    mika:   { name: "Mika",   role: "The Summer Girl",   jp: "ミカ" }
  }.freeze

  EXPRESSIONS = %i[ neutral smile surprise curious fun ].freeze

  # Who comments on a recipe, by its mood
  MOOD_HOSTS = {
    after_hours: :nagisa, midnight_romance: :nagisa, tokyo_rain: :nagisa, heartbreak: :nagisa,
    summer_night: :mika, golden_sunset: :mika, sweet_memories: :mika,
    neon_dreams: :reina
  }.freeze

  RECIPE_LINES = {
    nagisa: [ :neutral, "Some drinks are meant to be enjoyed slowly. Especially on nights like this." ],
    mika:   [ :smile, "This tastes like summer vacation. Don't you think?" ],
    reina:  [ :fun, "Now that's a drink that glows. Bold choice, I like it." ]
  }.freeze

  # Set by the hosts Stimulus controller when the visitor hides the hosts
  def hosts_hidden?
    cookies[:hosts_off] == "1"
  end

  def host_dialogue(host, expression, line, placement: nil)
    raise ArgumentError, "Unknown host: #{host}" unless HOSTS.key?(host)
    raise ArgumentError, "Unknown expression: #{expression}" unless EXPRESSIONS.include?(expression)

    render "shared/host_dialogue", host: host, details: HOSTS[host], expression: expression, line: line, placement: placement
  end

  # Hard recipes always get Reina's warning; otherwise the mood picks the host
  def recipe_host_dialogue(cocktail)
    if cocktail.hard?
      host_dialogue :reina, :fun, "Easy there! You're making a cocktail, not starting a hurricane.", placement: :end
    else
      host = MOOD_HOSTS.fetch(cocktail.mood.to_sym)
      expression, line = RECIPE_LINES.fetch(host)
      host_dialogue host, expression, line, placement: :end
    end
  end
end
