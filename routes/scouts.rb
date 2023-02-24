put('/scouts/:id/move/:car_id') do
  id = params["id"]
  car_id = params["car_id"]
  p id, car_id
  # TODO not found scout class
  Scout.move(id, car_id)
  p "moved scout #{id} to car id #{car_id}"
  #TODO remove status of scout
end

post('/scouts/:id/status') do
  Scout.update_status(params[:id], params[:status])

  redirect '/'
end
