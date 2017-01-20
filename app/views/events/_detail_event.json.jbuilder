json.extract! event, :id, :title, :start, :end, :transport, :address, :client_id, :program_id, :program_name, :meetingtype_id, :launch_break, :notes,:created_at, :updated_at, :color,:hours, :earnings, :hourly_rate, :is_paid, :is_confirmed,:date_confirmed,:meetingtype_name
json.total_hours @total_hours
json.total_earnings @total_earnings

#json.url event_url(event, format: :json)