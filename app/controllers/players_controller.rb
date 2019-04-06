require 'net/http'
require 'json'

class PlayersController < ApplicationController

  protect_from_forgery except: :web_player

  def index
    params.require(:user).permit!
    @playlists = Hash.new
    @user = RSpotify::User.new(params[:user]);
    #all tracks with a memory attached
    @tracks = Track.where(:username => @user.display_name).order(:playlist_name)
    #we need to organize the tracks and memories by playlist
    @tracks.each do |t|
      if @playlists[t.playlist_name].nil?
        @playlists[t.playlist_name] = []
      end
      #get playlist URI !!
      @user.playlists.each do |p|
        if p.name.eql? t.playlist_name
          @playlist_uri = p.uri
        end
      end

      @playlists[t.playlist_name] << [t.title, t.memory, t.imageurl, @playlist_uri]
    end

    @player_response = RSpotify.resolve_auth_request(@user.display_name, "me/player/")
    @current_song = @player_response
    if @current_song.nil?
      @current_song = " "
    else
      @current_song = @player_response['item']['name']
    end
  end
  #plays playlist
  def play
    params.require(:user).permit!
    @user = RSpotify::User.new(params[:user]);
    Rails.logger.debug "fuckk"
    Rails.logger.debug @user.inspect
    @uri = URI('https://api.spotify.com/v1/me/player/play')
    #request body tells spotify what playlist to play
    @body = {
      "context_uri": params[:playlist_uri]
    }.to_json
    #headers
    req = Net::HTTP::Put.new(@uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'Bearer ' + @user.credentials['token'].to_s})
    req.body = @body
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    response = http.start {|h|
      h.request(req)
    }
    sleep 1.5
    #redirecting to new action so the user can refresh the web player and not restart the playlist
    redirect_to :action => "web_player", :user => @user.to_hash, :playlist_info => params[:playlist_info]
  end

  def web_player
    params.require(:user).permit!
    @user = RSpotify::User.new(params[:user]);
    #get currrent song playing to decide what memory to display
    @player_response = RSpotify.resolve_auth_request(@user.display_name, "me/player/")
    @current_song = @player_response
    if @current_song.nil?
      @current_song = " "
    else
      @current_song = @player_response['item']['name']
    end

    @playlists = params[:playlist_info]
    @playlists_new = []
    #uhh so the playlists hash gets fucked so i'm rebuilding it here hehehe
    (@playlists.length/4).times do |t|
      @playlists_new << [@playlists[(t * 4)], @playlists[(t * 4) + 1], @playlists[(t * 4) + 2]]
    end
  end
end
