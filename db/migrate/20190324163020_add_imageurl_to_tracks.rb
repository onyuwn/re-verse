class AddImageurlToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :imageurl, :string
  end
end
