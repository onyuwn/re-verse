require 'json'

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
    if request.method.eql? "POST"
      params.require(:track).permit!
      if Track.where(:username => params[:track][:username], :title => params[:track][:title], :playlist_name => params[:track][:playlist_name]).empty?
        @track = Track.new(params[:track])
        @track.save
        @action = "created"
      else
        @track = Track.where(:username => params[:track][:username], :title => params[:track][:title], :playlist_name => params[:track][:playlist_name])
        @track.update(memory: params[:track][:memory])
        @action ="updated"
      end

      @user = RSpotify::User.find(params[:track][:username])
    else

    end
  end
end
