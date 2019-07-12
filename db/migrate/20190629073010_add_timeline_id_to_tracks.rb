class AddTimelineIdToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :timeline_id, :integer
  end
end
