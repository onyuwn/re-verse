require 'json'

class PlaylistsController < ApplicationController
  def index
    @user = RSpotify::User.new(session[:user])
    @playlists =  @user.playlists
  end

  def timeline
    @offset = params[:offset].to_i
    @playlist_name = params[:playlist]
    @user = RSpotify::User.new(session[:user])
    @playlists = @user.playlists

    @playlists.each do |p|
      if p.name.eql? @playlist_name
        @playlist = p
      end
    end

    if @offset >= @playlist.tracks.length
      @offset = 0
    elsif @offset < 0
      @offset = @playlist.tracks.length - 1
    end

    @tracks = Track.where(:username => @user.display_name, :playlist_name => @playlist_name).order(:title)

    @tracks.each do |t|
      if t.title.eql? @playlist.tracks[@offset].name
        @track = t
      end
    end

  end

  def edit
    @track = Track.where(username: session[:user]['display_name'], playlist_name: params[:playlist_name], title: params[:track_name]).order(:title)

    if request.method.eql? "POST"
      params.require(:track).permit!
      if Track.where(username: params[:track][:username], title: params[:track][:title], playlist_name: params[:track][:playlist_name]).empty?
        @track = Track.new(params[:track])
        @track.save
        @action = "created"
      else
        @track = Track.where(username: params[:track][:username], title: params[:track][:title], playlist_name: params[:track][:playlist_name])
        @track.update(memory: params[:track][:memory], imageurl: params[:track][:imageurl])
        @action ="updated"
      end

      @user = RSpotify::User.new(session[:user])
      redirect_to :action => "timeline", :user => @user.to_hash, :offset => params[:offset], :playlist => params[:track][:playlist_name]
    else

    end
  end
end
