class UsersController < ApplicationController
  def dashboard
    params.require(:user).permit!
    @user = RSpotify::User.new(params[:user])
  end

  def login
    @user = RSpotify::User.new(request.env['omniauth.auth'])
    redirect_to :action=>"dashboard", :user => @user.to_hash
  end
end
