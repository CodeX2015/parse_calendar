class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :url
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
