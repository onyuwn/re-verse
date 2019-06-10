class AddDateToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :memory_date, :date
  end
end
