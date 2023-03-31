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
  request.body.rewind
  status = request.body.read

  p status

  Scout.update_status(params[:id], status)

  return 200
end

post('/scout/add') do
  authorize!('admin')

  Scout.create(params['name'], "0")

  redirect('/admin/scout')
end

post('/scout/:id/delete') do
  authorize!('admin')

  Scout.delete(params[:id])

  redirect('/admin/scout')
end
