require_relative '../twilio.rb'

LAST_ATTEMPT = Hash.new(0)

get '/login' do
  slim(:'/users/login')
end

get '/logout' do
  session.clear
  redirect '/'
end

post '/login' do
  if Time.now.to_f - LAST_ATTEMPT[request.ip] < 1
    error 429
  end

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
    LAST_ATTEMPT[request.ip] = Time.now.to_f
    redirect '/login'
  end

  twilio_send_code(user.id)

  session[:maybe_user] = user.id
  redirect '/code'
end

get('/code') do
  slim(:'/users/code')
end

post('/code') do
  if Time.now.to_f - LAST_ATTEMPT[request.ip] < 1
    error 429
  end

  code = params[:code] 
  if twilio_verify_code(code) == session[:maybe_user]
    session[:user_id] = session[:maybe_user]
    redirect '/'
  else
    session[:error] = "Wrong code"
    LAST_ATTEMPT[request.ip] = Time.now.to_f
    redirect '/login'
  end


end

post('/user/add') do
  authorize!('admin')

  User.create(params['name'], params['phone'], params['role'])

  redirect('/admin/user')
end

post('/user/:id/delete') do
  authorize!('admin')

  User.delete(params[:id])

  redirect('/admin/user')
end

post '/user/:id/update' do
  authorize!('admin')

  user = User.find_by_id(params[:id])

  user.update(params['role'], params['car'])

  redirect('/admin/user')

end
