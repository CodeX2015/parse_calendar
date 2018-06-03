class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :tournaments, :date_from, :datetime
    change_column :tournaments, :date_to, :datetime
  end
end
