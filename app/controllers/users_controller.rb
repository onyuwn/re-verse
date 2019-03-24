class UsersController < ApplicationController
  def spotify
    @user = RSpotify::User.new(request.env['omniauth.auth'])
  end
end
