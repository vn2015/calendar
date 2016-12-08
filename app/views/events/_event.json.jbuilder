json.extract! event, :id, :title, :start, :end, :transport, :address,  :program_id, :meetingtype_id, :launch_break, :notes,:created_at, :updated_at, :color
json.total_hours @total_hours

#json.url event_url(event, format: :json)