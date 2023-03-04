require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require "sinatra/reloader"
require 'slim/include'

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
require_relative 'routes/scouts'

also_reload('models.rb', 'routes/car.rb', 'routes/user.rb', 'routes/scouts.rb')

enable :sessions

set :static_cache_control, [:public, max_age: 60]

get('/') do
  user = authorize!()

  p user
  p user.role

  if user.role == "parent"
    car = Car.get_by_userid(user.id)
    redirect '/cars/' + car.id.to_s
  elsif user.role == "leader"
    redirect '/cars'
  elsif user.role == "admin"
    redirect '/cars'
  end

end

error 401 do
  redirect '/login'
  halt 401, "Unauthorized"
end


