class UsersController < ApplicationController
  def dashboard
    params.require(:user).permit!

    respond_to do |format|
      format.html
      format.js
    end

    @user = RSpotify::User.new(params[:user])
  end

  def login
    @user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:user] = @user.to_hash
    timeline = Timeline.where(:name => @user.display_name, :creator => @user.display_name)
    user_memories = Track.where(:name => @user.display_name)
    user_moments = Moment.where(:name => @user.display_name)

    if timeline.count <= 0
      #first time user
      Timeline.new(:name => @user.display_name, :creator => @user.display_name,:subscribers => @user.display_name).save
      #redirect_to :controller=> "playlists",:action=>"index" #new users go str8 to timeline
      #send new users to tutorial
      session[:user] = 'jakeherman-3'
      redirect_to :controller => "tutorial", :action => "index" 
    else
      #see make sure their moments and tracks are linked
      if timeline[0].track.count == 0 && user_memories.count > 0
        user_memories.each do |mem|
          mem.timeline_id = timeline[0].id
          mom.save
        end
      end

      if timeline[0].track.count == 0 && user_moments.count > 0
        user_moments.each do |mom|
          mom.timeline_id = timeline[0].id
          mom.save
        end
      end
      redirect_to :controller=> "friends",:action=>"index" #regular users can go str9 to feed
    end
  end
end
