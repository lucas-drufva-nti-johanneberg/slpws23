# View car by id
#
# @param [Integer] :id, The id of the car
get('/cars/:id') do
  authorize!('leader')

  car = Car.get_by_id(params["id"])

  slim(:"cars/car", locals: {car: car})
end

# View all cars with filters
#
# @param [String] filter, "all" or group name
get('/cars') do
  user = authorize!('leader')

  session['filter'] = nil

  filter = params["filter"]

  if filter == "all" or user.groups.length == 0
    session['filter'] = "all"
    cars = Car.get_all()
  else
    cars = Car.get_all(user.groups)
  end

  slim(:"cars/cars", locals: {cars: cars})
end

# Update car status
#
# @param [Integer] :id, The id of the car
# @param [String] status, The new status
get('/cars/:id/status') do
  id = params[:id].to_i
  status = params["status"]

  # Check if user has permission to edit this
  user = authorize!()
  if user.role == "parent"
    error 403 unless user.car_id == id
  end

  Car.update_status(id, status)

  if user.role == "parent"
    redirect '/driver'
  else
    redirect '/cars/' + id
  end
end

get('/driver') do
  user = authorize!()

  car = Car.get_by_userid(user.id)

  slim(:"driver/page", locals: {car: car})

end
