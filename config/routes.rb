Rails.application.routes.draw do
  get 'playlists/timeline'
  get 'playlists/index'
  get 'playlists/edit'
  get 'welcome/index'
  get 'players/index'
  get 'players/play'
  get 'players/web_player'
  get 'users/dashboard'

  post 'playlists/timeline'
  post 'playlists/edit'

  resources :users

  get '/auth/spotify/callback', to: 'users#login'

  root 'welcome#index'
end
