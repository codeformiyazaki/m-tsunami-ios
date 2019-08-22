json.extract! apn_token, :id, :token, :type, :created_at, :updated_at
json.url apn_token_url(apn_token, format: :json)
