require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require "sinatra/reloader"

#1. Skapa ER + databas som kan hålla användare och todos. Fota ER-diagram, 
#   lägg i misc-mapp
#2. Skapa ett formulär för att registrerara användare.
#3. Skapa ett formulär för att logga in. Om användaren lyckas logga  
#   in: Spara information i session som håller koll på att användaren är inloggad
#4. Låt inloggad användare skapa todos i ett formulär (på en ny sida ELLER på sidan som visar todos.).
#5. Låt inloggad användare updatera och ta bort sina formulär.
#6. Lägg till felhantering (meddelande om man skriver in fel user/lösen)

# Att ta reda på, får man använda active record?

require_relative 'models'
require_relative 'utils'
require_relative 'routes/car'
require_relative 'routes/user'

also_reload('models.rb', 'routes/car.rb', 'routes/user.rb')

enable :sessions

get('/') do
  user = authorize!()

  p user
  p user.role

  if user.role == "parent"
    car = Car.get_by_userid(user.id)
    redirect '/car/#{car.id}'
  elsif user.role == "leader"
    redirect '/car'
  elsif user.role == "admin"
    redirect '/car'
  end

end


