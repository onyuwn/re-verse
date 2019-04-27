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
    redirect_to :controller=> "playlists",:action=>"index", :user => @user.to_hash
  end
end
