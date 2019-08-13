class AnalyticsController < ApplicationController
  def index
    @all_tls = Timeline.all
    @all_tracks = Track.all
  end

  def destroy_timeline
    Timline.where(:creator => params[:user]).destroy_all
  end
end
