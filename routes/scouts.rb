# Move scout by id to car
#
# @param [Integer] :id, The id of the scout
# @param [Integer] :car_id, The id of the car
put('/scouts/:id/move/:car_id') do
  id = params["id"]
  car_id = params["car_id"]
  Scout.move(id, car_id)
  p "moved scout #{id} to car id #{car_id}"
  #TODO remove status of scout
end

# Set scout status
# @param [Integer] :id, The id of the scout
# @param [String] body, The request body shall include the new scout status
post('/scouts/:id/status') do
  request.body.rewind
  status = request.body.read

  p status

  Scout.update_status(params[:id], status)

  return 200
end

# Add scout
# @param [String] name, The name of the scout
# @note Must be admin
# @note Assigns default parent phone number: 0, no car and no group
post('/scout/add') do
  authorize!('admin')

  Scout.create(params['name'], "0")

  redirect('/admin/scout')
end

# Delete scout
# @param [Integer] :id, The id of the scout
# @note Must be admin
# @note Assigns default parent phone number: 0, no car and no group
post('/scout/:id/delete') do
  authorize!('admin')

  Scout.delete(params[:id])

  redirect('/admin/scout')
end
