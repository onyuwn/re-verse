Rails.application.routes.draw do
  get 'playlists/timeline'
  get 'playlists/index'
  get 'playlists/add_memory'
  get 'playlists/edit' => 'playlists/edit', :as => :edit
  get 'welcome/index'
  get 'players/index'
  get 'playlists/destroy'
  get 'friends/index'
  get 'players/play'
  get 'players/web_player'
  get 'users/dashboard'
  get 'friends/unsubscribe'
  get 'analytics/index'
  
  post 'playlists/timeline'
  post 'playlists/edit'
  post 'playlists/add_memory'
  post 'playlists/index'

  resources :users

  get '/auth/spotify/callback', to: 'users#login'

  root 'welcome#index'
end
