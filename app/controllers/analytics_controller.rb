class AnalyticsController < ApplicationController
  def index
    @all_tls = Timeline.all
    @all_tracks = Track.all
    @all_moms = Moment.all
  end

  def destroy_timeline
    Timline.where(:creator => params[:user]).destroy_all
    redirect_to :action => 'index'
  end

  def destroy_moment
    Moment.where(:name => params[:moment], :user => params[:user]).destroy_all
    redirect_to :action => 'index'
  end
end
