json.extract! event, :id, :title, :start, :end, :transport, :address, :client_id, :program_id, :created_at, :updated_at
json.url event_url(event, format: :json)