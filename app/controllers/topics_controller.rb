class TopicsController < ApplicationController

  authorize_resource
  before_filter :find_forum
  

  def show
    @topic = Topic.where(:id => params[:id], :forum_id => params[:forum_id]).visible.first
    @topic.increment!(:views)
    @posts = @topic.posts.page(params[:page]).per(20)
  end
  
  def new
    @topic = @forum.topics.build
    @topic.posts.build  
  end
  
  def create
    @topic = @forum.topics.build(params[:topic])
    @topic.user = current_user
    if @topic.save
      flash[:notice] = "Thread was successfully posted."
      redirect_to [@forum, @topic]
    else
      flash[:error] = "There was a problem creating this thread"
      render :action => :new
    end
  end
  
  
  
  protected
  
  def register_view
    @topic.increment!(:views)
  end
  
  
  def find_forum
    @forum = Forum.find(params[:forum_id])
  end


end
