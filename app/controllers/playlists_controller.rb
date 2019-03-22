class PlaylistsController < ApplicationController
  def index
    params.require(:user).permit!
    @user = RSpotify::User.new(params[:user])
    @playlists =  @user.playlists
  end

  def timeline
    params.require(:user).permit!
    @playlist_name = params[:playlist]
    @user = RSpotify::User.new(params[:user])
    @playlists = @user.playlists

    @playlists.each do |p|
      if p.name.eql? @playlist_name
        @playlist = p
      end
    end
  end

  def edit

  end
end
