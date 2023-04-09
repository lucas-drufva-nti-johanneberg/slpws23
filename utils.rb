def authorize!(role="parent")
  if session[:user_id] == nil
    error 401
  end

  user = User.find_by_id(session[:user_id])

  p user.role
  
  if role == "leader" and (user.role != "leader" and user.role != "admin")
    error 403
  end

  if role == "admin" and user.role != "admin"
    error 403
  end


  return user

end
