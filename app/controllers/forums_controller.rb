class ForumsController < ApplicationController
  authorize_resource

  def index
    @forums = Forum.all
  end
  
  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.visible.by_pinned_or_most_recent_comment.page(params[:page]).per(20)
    @topics_count =  @forum.topics.visible.by_pinned_or_most_recent_comment.count
  end




end
