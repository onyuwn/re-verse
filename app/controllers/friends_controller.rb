class FriendsController < ApplicationController
  def index
    begin
      @user = RSpotify::User.new(session[:user])
    rescue NoMethodError => e
      Rails.logger.info "users first time >:)"
      @user = RSpotify::User.new(session[:me])
      session[:user] = session[:me]
    end

    @sharedtls = Timeline.where("subscribers LIKE ?", "%" + @user.email.to_s + "%")
    @subscribers = Timeline.where(:name => @user.email.to_s)[0].subscribers.split(',')
    @moment_count = Moment.where(:user => @user.email.to_s).length
    @memory_count = Track.where(:username => @user.email.to_s).length
    #make a post for every new memory and moment and when user shares timeline w u
    @memory_posts = []
    @sharedtls.each do |st|
      st.track.each do |track|
        if track.updated_at > (Time.now - 86400)
          @memory_posts << track
        end
      end
    end
  end

  def unsubscribe
    tl = Timeline.where(:name => params[:timeline])[0]
    new_subs = tl.subscribers.split(RSpotify::User.new(session[:user]).email.to_s)
    tl = Timeline.update_all(:subscribers => new_subs)
    redirect_to(:action=>'index')
  end

  def friend_timeline
    #view friend's timeline
  end
end
