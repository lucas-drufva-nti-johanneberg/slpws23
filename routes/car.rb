get('/cars/:id') do

  car = Car.get_by_id(params["id"])

  slim(:"cars/car", locals: {car: car})
end

get('/cars') do
  user = authorize!()

  cars = Car.get_all()

  p "bilar"
  p cars

  slim(:"cars/cars", locals: {cars: cars})
end

#put('/scouts')
