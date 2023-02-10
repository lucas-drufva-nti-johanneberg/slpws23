put('/scouts/:id/move/:car_id') do
  id = params["id"]
  car_id = params["car_id"]
  p id, car_id
  # TODO not found scout class
  Scout.update(id, car_id)
  p "Updated scout"
end
