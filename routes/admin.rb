get('/admin') do
  authorize!("admin")

  slim(:admin)
end

get('/admin/scout') do
  authorize!("admin")

  scouts = Scout.get_all()
  slim(:"admin/scouts", locals: {scouts: scouts})
end

get('/admin/user') do
  authorize!("admin")

  users = User.get_all()
  cars = Car.get_all()
  slim(:"admin/users", locals: {users: users, cars: cars})
end
