require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require "sinatra/reloader"
require 'slim/include'

require_relative 'models'
require_relative 'utils'
require_relative 'routes/car'
require_relative 'routes/user'
require_relative 'routes/scouts'
require_relative 'routes/admin'

also_reload('models.rb', 'routes/car.rb', 'routes/user.rb', 'routes/scouts.rb', 'routes/admin.rb')

enable :sessions

set :static_cache_control, [:public, max_age: 60]

before do
  if request.path_info != "/login" and request.path_info != "/code" 
      authorize!()
  end
end

get('/') do
  user = authorize!()

  p user
  p user.role

  if user.role == "parent"
    redirect '/driver'
  elsif user.role == "leader"
    redirect '/cars'
  elsif user.role == "admin"
    redirect '/admin'
  end

end



error 401 do
  redirect '/login'
  halt 401, "Unauthorized"
end

error 403 do
  halt 403, "Forbidden"
end

error 429 do
  halt 429, "Too Many Requests"
end


