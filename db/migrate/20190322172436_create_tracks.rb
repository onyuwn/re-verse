class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :playlist_name
      t.text :memory
      t.string :username

      t.timestamps
    end
  end
end
