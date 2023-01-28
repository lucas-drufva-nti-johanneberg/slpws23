get('/car/:id') do

  car = Car.get_by_id(params["id"])

  return "my car #{params['id']}"
end

get('/car') do
 return "All cars"
end
