class AddLastUpdateToTimeline < ActiveRecord::Migration[5.2]
  def change
    add_column :timelines, :last_update, :timestamp
  end
end
