class AddTimelineIdToMoments < ActiveRecord::Migration[5.2]
  def change
    add_column :moments, :timeline_id, :integer
  end
end
