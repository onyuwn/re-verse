class SharedController < ApplicationController
  protect_from_forgery except: :find_track_for_memory
  protect_from_forgery except: :add_memory

  def index
    @tracks = Track.where(:username => params[:shared])
  end

end
