class VotesController < ApplicationController
  require 'ipaddr'
  def new
    @vote = Vote.new
    @vote.vote_event_id = params[:vote_event_id] || VoteEvent.last.id
  end

  def create
    @vote = Vote.new(params[:vote])
    @vote.vote_event_id = params[:vote_event_id] || VoteEvent.last.id
    @vote.user = current_user
    @vote.ip_address = IPAddr.new(request.remote_ip).to_i
    unless @vote.save
      flash[:notice] = "We could not save your vote"
    end
    redirect_to vote_path
  end

end
