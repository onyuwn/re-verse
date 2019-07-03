class FriendsController < ApplicationController
  def index
    @user = RSpotify::User.new(session[:user])
    @shared_timelines = []
    @sharedtls = Timeline.where("subscribers LIKE ?", "%" + @user.display_name.to_s + "%")
    @following = [] #list of usernames that this user is following

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
end
