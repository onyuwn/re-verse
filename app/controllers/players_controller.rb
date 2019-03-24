require 'net/http'

class PlayersController < ApplicationController
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

      @playlists[t.playlist_name] << [t.title, t.memory, @playlist_uri]
    end

    @player_response = RSpotify.resolve_auth_request(@user.display_name, "me/player/")
    @current_song = @player_response['item']['name']
  end

  def play
    params.require(:user).permit!
    @user = RSpotify::User.new(params[:user]);
    @uri = URI('https://api.spotify.com/v1/me/player/play')
    @body = {
      "context_uri": params[:playlist_uri]
    }.to_json
    req = Net::HTTP::Put.new(@uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'Bearer ' + @user.credentials['token'].to_s})
    req.body = @body
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    response = http.start {|h|
      h.request(req)
    }
    redirect_to :action => "index", :user => @user.to_hash
  end
end
