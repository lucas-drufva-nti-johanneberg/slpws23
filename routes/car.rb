get('/cars/:id') do

  car = Car.get_by_id(params["id"])

  slim(:"cars/car", locals: {car: car})
end

get('/cars') do
  user = authorize!()

  session['filter'] = nil

  filter = params["filter"]

  p "groups:"
  p user.groups

  if filter == "all" or user.groups.length == 0
    session['filter'] = "all"
    cars = Car.get_all()
  else
    # todo get real filter
    cars = Car.get_all(user.groups)
  end

  slim(:"cars/cars", locals: {cars: cars})
end

get('/cars/:id/status') do
  id = params[:id]
  status = params["status"]

  p status

  Car.update_status(id, status)

  redirect '/cars/' + id
end
