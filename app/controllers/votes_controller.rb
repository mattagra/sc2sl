class VotesController < ApplicationController

    authorize_resource
    cache_sweeper :vote_sweeper

  require 'ipaddr'
  def new
    vote_event_id = params[:vote_event_id] || VoteEvent.last.id
    @vote = Vote.find_by_vote_event_id_and_user_id(vote_event_id, current_user.id) || Vote.new(:vote_event_id => vote_event_id)
  end

  def create
    @vote = Vote.new(params[:vote])
    @vote.vote_event_id = params[:vote_event_id] || VoteEvent.last.id
    @vote.user = current_user
    @vote.ip_address = IPAddr.new(request.remote_ip).to_i
    unless @vote.save
      flash[:notice] = "You have already voted on this computer"
    end
    redirect_to vote_path
  end

end
