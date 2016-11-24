json.extract! event, :id, :title, :start, :end, :transport, :address, :client_id, :program_id, :meetingtype_id, :notes,:created_at, :updated_at, :color
json.total_hours @total_hours

#json.url event_url(event, format: :json)