class PlayersController < ApplicationController
  def index
    @playlists = Hash.new
    @user = RSpotify::User.new(params[:user]);
    #all tracks with a memory attached
    @tracks = Track.where(:username => @user.display_name).order(:playlist_name)
    #we need to organize the tracks and memories by playlist
    @tracks.each do |t|
      if @playlists[t.playlist_name].nil?
        @playlists[t.playlist_name] = []
      end

      @playlists[t.playlist_name] << [t.title, t.memory]
    end

    @playlists.each do |key, val|
      Rails.logger.debug key
    end

  end
end
