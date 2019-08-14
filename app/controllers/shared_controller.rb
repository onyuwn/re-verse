class SharedController < ApplicationController
  protect_from_forgery except: :find_track_for_memory
  protect_from_forgery except: :add_memory

  def index
    if params[:new_item] != nil
      @focused_memory = params[:new_item].to_s.gsub(/[^a-z ]/, '').gsub(/\s+/, "")
    end
    @me = RSpotify::User.new(session[:user])
    @user = RSpotify::User.find(params[:shared])
    @current_timeline = Timeline.where(:creator => @user.email)
    #make sure the
    if !@current_timeline[0].subscribers.split(',').include? @me.email
      redirect_to :controller => 'friends', :action => 'index'
    end

    @playlists =  @user.playlists
    @tracks = Track.where(:username => @user.email).order(:memory_date)
    @moments = Moment.where(:user => @user.email)

    @months = {}

    @moments.each do |m|
      @months[m.start_date.month] = @months[m.start_date.month].to_i + 1
    end

    @tracks_array = @tracks.to_a #tracks (memories)

    @tlhash = {} # {month-int => [track, playlist, track..]} each array is sorted by date later..
    @momenthash = {}
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

          matched_playlist.tracks.each do |pt| #match track name to rspotify track object
            if pt.name.eql? t.title
              new_track << pt #add track object in along with memory
            end
          end
          moment_item = false
          @moments.each do |m|
            if t.memory_date <= m.end_date and t.memory_date >= m.start_date
              new_track << m
              moment_item = true
            end
          end

          if moment_item == true
            if @momenthash[new_track[2].start_date.month] == nil
              @momenthash[new_track[2].start_date.month] = []
            end
            @momenthash[new_track[2].start_date.month] << new_track
          else
            @tlhash[t.memory_date.month] << new_track
            @months[t.memory_date.month] = @months[t.memory_date.month].to_i + 1
          end
          @tracks_array.delete_at(i)
        end
      end
      @tlhash[p.tracks_added_at[p.tracks_added_at.keys[0]].month] << p
    end

    #iterate over each entry in tl hash and sort array by date

    @tlhash.each do |k, v| # v - array
      moment_index = 0
      items_sorted = []
      datehash = {}
      month_moment = @momenthash[k]
      v.each do |i|
        if i.class == RSpotify::Playlist
          playlistday = i.tracks_added_at.values[0].to_date.day
          if datehash[playlistday] == nil
            datehash[playlistday] = [] #make each date in hash an array in case items share a date
          end
          datehash[playlistday] << i
        else #memory/moment-item
          itemday = i[0].memory_date.day
          if datehash[itemday] == nil
            datehash[itemday] = []
          end
          datehash[itemday] << i
        end
      end

      (1..datehash.keys.max).each do |day| #iterate over every day in month
        if datehash[day] != nil
          datehash[day].reverse.each do |j| #iterate over items from that day (usually one, but someone could have multiple things on the same day)
            items_sorted << j #if item in that day plop it in
          end
        end
      end
      @tlhash[k] = [items_sorted, month_moment]
    end

    @months_colors = {1 => "#5f7ed4", 2 => "#d45f80", 3 => "#5fd488", 4 => "#5fced4", 5 => "#d4d25f", 6 => "#d4945f", 7 => "#b15fd4", 8 => "#d4765f", 9 => "#5fd4ad", 10 => "#d49d5f", 11 => "#735fd4", 12 => "#e5f2a0"}

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
          current_subs = Timeline.where(:creator => @user.email)[0].subscribers.to_s
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
        redirect_to :action => "index", :controller => "playlists", :new_item => params[:track][:title].gsub(/[^a-z ]/, '').gsub(/\s+/, "")
      end
    end
    Rails.logger.info @months.inspect
  end

  def timeline
    @playlist_name = params[:playlist]
    @track_name = params[:track]
    @user = RSpotify::User.new(session[:user])
    @playlists = @user.playlists
    @current_timeline = Timeline.where(:creator => @user.email)

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

    @tracks = Track.where(:username => @user.email, :playlist_name => @playlist_name, :title => @track_name)

    @playlists_h = {}
    @playlists.each do |p|
      track_names = []
      p.tracks.each do |t|
        track_names << t.name
      end
      @playlists_h[p.name] = track_names
    end
  end
end
