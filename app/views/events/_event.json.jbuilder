json.extract! event, :id, :title, :start, :end, :transport, :address, :client_id, :program_id, :program_name, :meetingtype_id, :launch_break, :notes,:created_at, :updated_at, :color,:meetingtype_name

#json.url event_url(event, format: :json)