json.extract! tournament, :id, :year, :date, :city, :event_name, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
