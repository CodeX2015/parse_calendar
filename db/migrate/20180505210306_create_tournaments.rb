class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
      t.string :organizer
      t.string :city
      t.string :date_from
      t.string :date_to
      t.string :event_name
      t.string :condition_link
      t.string :forum_link
      t.boolean :is_photo_report
      t.boolean :is_video_report

      t.timestamps
    end
  end
end
