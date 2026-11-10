module HostsHelper
  # The hosts of the bar: anime characters who comment on each page
  HOSTS = {
    nagisa: { name: "Nagisa", role: "The Midnight Muse", jp: "ナギサ" },
    reina:  { name: "Reina",  role: "The Bartender",     jp: "レイナ" },
    mika:   { name: "Mika",   role: "The Summer Girl",   jp: "ミカ" }
  }.freeze

  EXPRESSIONS = %i[ neutral smile surprise curious fun ].freeze

  def host_dialogue(host, expression, line, placement: nil)
    raise ArgumentError, "Unknown host: #{host}" unless HOSTS.key?(host)
    raise ArgumentError, "Unknown expression: #{expression}" unless EXPRESSIONS.include?(expression)

    render "shared/host_dialogue", host: host, details: HOSTS[host], expression: expression, line: line, placement: placement
  end
end
