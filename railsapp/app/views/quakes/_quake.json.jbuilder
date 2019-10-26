json.extract! quake, :id, :device_id, :elapsed, :p, :s, :created_at, :updated_at
json.url quake_url(quake, format: :json)
