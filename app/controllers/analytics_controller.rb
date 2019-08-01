class AnalyticsController < ApplicationController
  def index
    @all_tls = Timeline.all
    @all_tracks = Track.all
  end
end
