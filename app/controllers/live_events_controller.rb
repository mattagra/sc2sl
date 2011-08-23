class LiveEventsController < ApplicationController

  authorize_resource
  def index
    @live_events = LiveEvent.order("id desc")
  end

  def show
    @live_event = LiveEvent.find(params[:id])
  end

  def current
    @live_event = LiveEvent.where(:enabled => true).last
  end

  def edit
    @live_event = LiveEvent.find(params[:id])
  end

  def new
    @live_event = LiveEvent.new
  end

  def create
    @live_event = LiveEvent.new(params[:live_event])
    if @live_event.save
      redirect_to @live_event
    end
  end

  def update
    @live_event = LiveEvent.find(params[:id])
    if @live_event.update_attributes(params[:live_event])
      redirect_to @live_event
    end

  end

  def destroy
    @live_event = LiveEvent.find(params[:id])
    @live_event.destroy
    redirect_to :action => :index
  end

end
