class VoteEventsController < ApplicationController

    authorize_resource

  def index
    @vote_events = VoteEvent.all
  end

  def show
    @vote_event = VoteEvent.find(params[:id])
    @vote = Vote.new
    @vote.vote_event = @vote_event
  end

  def show_current
    @vote_event = VoteEvent.last
    @vote = Vote.new
    @vote.vote_event = @vote_event
    render :action => :show
  end

  def new
    @vote_event = VoteEvent.new(:match_id => params[:match_id])
  end

  def create
    @vote_event = VoteEvent.new(params[:vote_event])
    @vote_event.match_id = params[:match_id]
    if @vote_event.save
      redirect_to :action => :show, :id => @vote_event.id
    end
  end

  def destroy
    @vote_event = VoteEvent.find(params[:id])
    @vote_event.destroy
    redirect_to :action => :index
  end

end
