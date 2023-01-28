def authorize!(role="parent")
  if session[:user_id] == nil
    error 401
  end

  user = User.find_by_id(session[:user_id])
  
  if role == "leader" and user.role != "leader"
    error 403
  end

  return user

end
