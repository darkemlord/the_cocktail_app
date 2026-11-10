# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Demo data for local development only
return unless Rails.env.development?

seeds = {
  "ana@cocktails.test" => [
    {
      name: "Negroni",
      difficulty: :easy,
      ingredients: "30 ml gin\n30 ml Campari\n30 ml vermouth rosso\nOrange peel",
      instructions: "Stir all ingredients with ice in a mixing glass. Strain into a rocks glass over a large ice cube and garnish with the orange peel."
    },
    {
      name: "Mojito",
      difficulty: :medium,
      ingredients: "50 ml white rum\n25 ml lime juice\n2 tsp sugar\n8 mint leaves\nSoda water",
      instructions: "Gently muddle the mint with sugar and lime juice. Add rum and crushed ice, top with soda water and stir."
    },
    {
      name: "Ramos Gin Fizz",
      difficulty: :hard,
      ingredients: "45 ml gin\n15 ml lemon juice\n15 ml lime juice\n30 ml simple syrup\n60 ml cream\n1 egg white\n3 drops orange flower water\nSoda water",
      instructions: "Dry shake everything except soda for a minute, then shake hard with ice. Strain into a highball glass and slowly top with soda until the foam rises."
    }
  ],
  "beto@cocktails.test" => [
    {
      name: "Old Fashioned",
      difficulty: :easy,
      ingredients: "60 ml bourbon\n1 sugar cube\n2 dashes Angostura bitters\nOrange peel",
      instructions: "Muddle the sugar with the bitters and a splash of water. Add bourbon and ice, stir until chilled and garnish with the orange peel."
    },
    {
      name: "Margarita",
      difficulty: :medium,
      ingredients: "50 ml tequila\n25 ml triple sec\n25 ml lime juice\nSalt",
      instructions: "Rim a glass with salt. Shake tequila, triple sec and lime juice with ice and strain into the glass."
    }
  ]
}

seeds.each do |email, cocktails|
  user = User.find_or_create_by!(email_address: email) do |u|
    u.password = "password"
  end

  cocktails.each do |attributes|
    user.cocktails.find_or_create_by!(name: attributes[:name]) do |cocktail|
      cocktail.assign_attributes(attributes)
    end
  end
end

puts "Seeded #{User.count} users and #{Cocktail.count} cocktails"
