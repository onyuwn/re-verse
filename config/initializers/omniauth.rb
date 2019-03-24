require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "4d98751cb2b041409a3db5c736bb2f7e", "861e01fc5d9242a59fcf78615ae167e5", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify app-remote-control streaming user-read-playback-state user-modify-playback-state user-read-currently-playing user-read-recently-played'
end
