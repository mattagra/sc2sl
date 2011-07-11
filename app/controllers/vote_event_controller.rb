class VoteEventController < ApplicationController
  def index
    @vote_events = VoteEvent.all
  end

  def show
    @vote_event = VoteEvent.find(params[:id])
  end

  def new
    @vote_event = VoteEvent.new
  end

  def create
    @vote_event = VoteEvent.new(params[:vote_event])
    if @vote_event.save
      redirect_to @vote_event
    end
  end

  def destroy
    @vote_event = VoteEvent.find(params[:id])
    @vote_event.destroy
    redirect_to :action => :index
  end

end
