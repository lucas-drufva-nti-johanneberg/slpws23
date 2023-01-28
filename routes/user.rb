get '/login' do
  slim(:'/users/login')
end


get '/logout' do
  session.clear
  redirect '/'
end

post '/register' do
  # TODO error checking
  # Check password retype matching
  
  session[:error] = nil

  name = params[:name]
  password = params[:password]
  password2 = params[:password2]

  if password != password2
    session[:error] = "Passwords not matching"
    redirect '/register'
  end

  begin

    if session[:user_id] != nil
      user = User.find_by_id(session[:user_id])

      if user.role == "user"
        # User is already registred
        redirect '/'
      end
      
      user.update_user(name, password, "user")
    else
      user_id = User.create(name, password, "user")
      session[:user_id] = user_id
    end
  rescue UserError => error
    session[:error] = error.message
    redirect '/register'
  end

    
  redirect '/'
end

post '/login' do
  session[:error] = nil

  if session[:user_id] != nil
      user = User.find_by_id(session[:user_id])

      redirect '/'
  end

  phone = params[:phone]

  user = User.find_by_phone(phone)

  if user == nil
    #TODO error should not be seen risking data leak
    session[:error] = "User not found"
    redirect '/login'
  end

  session[:user_id] = user.id
  redirect '/'
end
