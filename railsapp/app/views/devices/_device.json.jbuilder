json.extract! device, :id, :name, :desc, :active, :created_at, :updated_at
json.url device_url(device, format: :json)
