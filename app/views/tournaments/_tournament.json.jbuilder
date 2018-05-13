json.extract! tournament, :id, :organizer, :date_from, :date_to, :city, :event_name, :condition_link, :forum_link, :is_photo_report, :is_video_report, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
