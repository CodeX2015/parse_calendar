class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
      t.integer :year
      t.string :date
      t.string :city
      t.string :event_name

      t.timestamps
    end
  end
end
