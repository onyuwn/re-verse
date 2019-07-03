require 'json'
require 'time'
require 'rmagick'
require 'net/http'
require 'open-uri'
require 'json'

class PlaylistsController < ApplicationController
  protect_from_forgery except: :find_track_for_memory
  protect_from_forgery except: :add_memory

  def index
    @user = RSpotify::User.new(session[:user])
    @current_timeline = Timeline.where(:creator => @user.display_name)
    @playlists =  @user.playlists
    @tracks = Track.where(:username => @user.display_name).order(:memory_date)
    @moments = Moment.where(:user => @user.display_name)

    @months = {}

    # #TODO: make date picker
    # count = 1
    # @tracks.each do |t|
    #   t.memory_date = Date.new(2019, rand(1..12), rand(1..25))
    #   count += 1
    #   t.save
    # end
    @tracks_array = @tracks.to_a #tracks (memories)
    @tlhash = {} # {month-int => [track, playlist, track..]} each array is sorted by date later..
    @playlists.each do |p|
      if @tlhash[p.tracks_added_at[p.tracks_added_at.keys[0]].month] == nil
        @tlhash[p.tracks_added_at[p.tracks_added_at.keys[0]].month] = []
      end
      @months[p.tracks_added_at[p.tracks_added_at.keys[0]].month] = @months[p.tracks_added_at[p.tracks_added_at.keys[0]].month].to_i + 1
      if @tracks_array.length > 0
        @tracks_array.each_with_index do |t, i|
          if @tlhash[t.memory_date.month] == nil
            @tlhash[t.memory_date.month] = []
          end
          new_track = []
          new_track << t #track memory
          #match track to track data by looking more into playlist
          matched_playlist = []
          @playlists.each do |pp|
            if pp.name.eql? t.playlist_name
              matched_playlist = pp
            end
          end

          @months[t.memory_date.month] = @months[t.memory_date.month].to_i + 1
          matched_playlist.tracks_cache.each do |pt| #match track name to rspotify track object
            if pt.name.eql? t.title
              new_track << pt #add track object in along with memory
            end
          end

          @moments.each do |m|
            if t.memory_date <= m.end_date and t.memory_date >= m.start_date
              new_track << m
            end
          end
          @tlhash[t.memory_date.month] << new_track
          @tracks_array.delete_at(i)
        end
      end
      @tlhash[p.tracks_added_at[p.tracks_added_at.keys[0]].month] << p
    end
    #
    # @month_color_scheme = {}
    # #get a color scheme for each month in the tlhash..
    # image = Magick::ImageList.new
    # @tlhash.keys.each do |k|
    #   pixels = [] #pixels to be dumped into colormind
    #   @tlhash[k].each do |t|
    #     if t.class != RSpotify::Playlist
    #       urlimage = open(t[1].album.images[0]['url'])
    #       image.from_blob(urlimage.read)
    #       count = 0
    #       image.each_pixel do |pixel, c, r|
    #         begin
    #           pixels << [pixel.to_color[1..2].to_i(16), pixel.to_color[3..4].to_i(16), pixel.to_color[5..6].to_i(16)]
    #           count = count + 1
    #           if count > 100
    #             break
    #           end
    #         rescue ArgumentError => e
    #           Rails.logger.info "oopsies!"
    #           break
    #         end
    #       end
    #     end
    #   end
    #
    #   data = {
    #     :model => "default",
    #     :input => pixels
    #   }
    #
    #   url = URI.parse('http://colormind.io/api/')
    #   req = Net::HTTP::Get.new(url.to_s, {'Content-Type': 'text/json'})
    #   req.body = data.to_json
    #   res = Net::HTTP.start(url.host, url.port) {|http|
    #     http.request(req)
    #   }
    #   color_results = JSON.parse(res.body)['result'] #2d array of 5 rgb values [[r,g,b], [], ...]
    #   @month_color_scheme[k] = color_results
    # end
    #
    # Rails.logger.info @month_color_scheme.inspect

    #iterate over each entry in tl hash and sort array by date
    @moments = {}
    @tlhash.each do |k, v| # v - array
      moment_index = 0
      items_sorted = []
      datehash = {}
      v.each do |i|
        if i.class == RSpotify::Playlist
          playlistday = i.tracks_added_at.values[0].to_date.day
          if datehash[playlistday] == nil
            datehash[playlistday] = [] #make each date in hash an array in case items share a date
          end
          datehash[playlistday] << i
        else #memory/moment-item
          if i[i.length - 1].class == Moment #the last element of each item array is the moment tag
            if datehash[i[i.length - 1].created_at.day] == nil
              datehash[i[i.length - 1].created_at.day] = []
              datehash[i[i.length - 1].created_at.day] << {i[i.length - 1].name.to_s => [i]}
            elsif datehash[i[i.length - 1].created_at.day] != nil
              datehash.each do |dk, dv|
                if datehash[dk].class == Hash
                  datehash[i[i.length - 1].created_at.day][moment_index][i[i.length - 1].name.to_s] << i
                end
              end
            end
          else
            if datehash[i[0].memory_date.day] == nil
              datehash[i[0].memory_date.day] = []
            end
            datehash[i[0].memory_date.day] << i
          end
        end
      end

      (1..datehash.keys.max).each do |day| #iterate over every day in month
        if datehash[day] && datehash[day].any? && datehash[day].class == Array
          datehash[day].reverse.each do |j| #iterate over items from that day (usually one, but someone could have multiple things on the same day)
            items_sorted << j #if item in that day plop it in
          end
        elsif datehash[day].class == Hash
          items_sorted << datehash[day]
        end
      end
      @tlhash[k] = items_sorted
    end

    @months_colors = {1 => "blue", 2 => "red", 3 => "orange", 4 => "yellow", 5 => "green", 6 => "blue", 7 => "purple", 8 => "red", 9 => "orange", 10 => "yellow", 11 => "green", 12 => "blue"}

    @playlists_h = {}
    @playlists.each do |p|
      track_names = []
      p.tracks.each do |t|
        track_names << t.name
      end
      @playlists_h[p.name] = track_names
    end

    if request.method.eql? "POST"
      if params[:track].eql? nil
        if params[:moment].eql? nil
          params.require(:timeline).permit!
          current_subs = Timeline.where(:creator => @user.display_name)[0].subscribers.to_s

          Timeline.create(:creator => params[:timeline][:creator], :subscribers => current_subs + "," + params[:timeline][:subscribers].to_s, :name => params[:timeline][:name])
        else
          params.require(:moment).permit!
          Moment.new(params[:moment]).save
        end
      else
        Rails.logger.debug "saving new track"
        Rails.logger.debug params[:track]
        params.require(:track).permit!
        t = Track.new(params[:track])
        t.save
        Rails.logger.debug t.errors.full_messages
      end
    end
  end

  def timeline
    @playlist_name = params[:playlist]
    @track_name = params[:track]
    @user = RSpotify::User.new(session[:user])
    @playlists = @user.playlists
    @current_timeline = Timeline.where(:creator => @user.display_name)

    @playlists.each do |p|
      if p.name.eql? @playlist_name
        @playlist = p
        break
      end
    end

    @playlist.tracks.each do |t|
      if t.name.eql? @track_name
        @track = t
        break
      end
    end

    @tracks = Track.where(:username => @user.display_name, :playlist_name => @playlist_name, :title => @track_name)

    @playlists_h = {}
    @playlists.each do |p|
      track_names = []
      p.tracks.each do |t|
        track_names << t.name
      end
      @playlists_h[p.name] = track_names
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
