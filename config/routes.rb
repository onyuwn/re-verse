Rails.application.routes.draw do
  get 'playlists/timeline'
  get 'playlists/index'
  get 'playlists/edit'
  get 'welcome/index'
  get 'players/index'
  get 'players/play'

  post 'playlists/timeline'
  post 'playlists/edit'

  resources :users

  get '/auth/spotify/callback', to: 'users#spotify'

  root 'welcome#index'
end
