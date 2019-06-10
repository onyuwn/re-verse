require 'json'
require 'time'

class PlaylistsController < ApplicationController
  protect_from_forgery except: :find_track_for_memory
  protect_from_forgery except: :add_memory

  def index
    @user = RSpotify::User.new(session[:user])
    @playlists =  @user.playlists
    @tracks = Track.where(:username => @user.display_name).order(:memory_date)
    @moments = Moment.where(:username => @user.display_name)
    #TODO: make date picker
    count = 1
    @tracks.each do |t|
      t.memory_date = Date.new(2019, rand(1..12), rand(1..25))
      count += 1
      t.save
    end
    @tracks_array = @tracks.to_a
    @timeline = []
    @playlists.each do |p|
      p_time = p.tracks_added_at[p.tracks_added_at.keys[0]]
      if @tracks_array.length > 0
        @tracks_array.each_with_index do |t, i|
          if t.memory_date > Date.new(p_time.year, p_time.month, p_time.day)
            new_track = []
            new_track << t #track memory
            #match track to track data by looking more into playlist
            matched_playlist = []
            @playlists.each do |pp|
              if pp.name.eql? t.playlist_name
                matched_playlist = pp
              end
            end
            matched_playlist.tracks_cache.each do |pt|
              if pt.name.eql? t.title
                new_track << pt #add track object in along with memory
              end
            end
            @timeline << new_track
            @tracks_array.delete_at(i)
          end
        end
      else
        break
      end
      @timeline << p
    end

    @playlists_h = {}
    @playlists.each do |p|
      track_names = []
      p.tracks.each do |t|
        track_names << t.name
      end
      @playlists_h[p.name] = track_names
    end

    if request.method.eql? "POST"
      params.require(:track).permit!
      Track.new(params[:track]).save
    end
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

    respond_modal_with @track

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

  def create
    track = new Track()
  end

end
