class UsersController < ApplicationController
  def spotify
    @user = RSpotify::User.new(request.env['omniauth.auth'])
    Rails.logger.debug "aye"
    Rails.logger.debug @user.inspect
  end
end
