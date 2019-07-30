class FriendsController < ApplicationController
  def index
    @user = RSpotify::User.new(session[:user])
    @sharedtls = Timeline.where("subscribers LIKE ?", "%" + @user.display_name.to_s + "%")
    @subscribers = Timeline.where(:name => @user.display_name.to_s)[0].subscribers.split(',')
    @moment_count = Moment.where(:user => @user.display_name.to_s).length
    @memory_count = Track.where(:username => @user.display_name.to_s).length
    #make a post for every new memory and moment and when user shares timeline w u
    @memory_posts = []
    @sharedtls.each do |st|
      st.track.each do |track|
        if track.updated_at > (Time.now - 86400)
          @memory_posts << track
          Rails.logger.debug track.updated_at
          Rails.logger.debug (Time.now - 86400)
          Rails.logger.debug (Time.now)
        end
      end
    end
  end

  def unsubscribe
    tl = Timeline.where(:name => params[:timeline])[0]
    new_subs = tl.subscribers.split(RSpotify::User.new(session[:user]).display_name.to_s)
    tl = Timeline.update_all(:subscribers => new_subs)
    redirect_to(:action=>'index')
  end

  def friend_timeline
    #view friend's timeline
  end
end
