class PostsController < ApplicationController

  authorize_resource
  before_filter :find_topic
  
  def new
    @post = @topic.posts.build    
  end
  
  def create
    if @topic.locked? or @topic.hidden?
      flash[:notice] = "That topic has been deleted or locked."
      redirect_to @topic.forum and return
    end
    @post = @topic.posts.build(params[:post])
    @post.user = current_user
    if @post.save
      flash[:notice] = "Post has been created"
      redirect_to [@topic.forum, @topic]
    else
      flash[:warning] = "Something prevented the post from being saved"
      render :action => :new
    
    end
  
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  
  def update
    @post = Post.find(params[:id])
    if (@topic.locked? or @topic.hidden?) and !current_admin
      flash[:notice] = "That topic has been deleted or locked."
      redirect_to @topic.forum and return
    end
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was updated"
      redirect_to [@topic.forum, @topic]
    else
      flash[:warning] = "Something prevented this post from being updated."
      render :action => :edit
    end
  end
  
  
  
  
  
  
  def find_topic
    @topic = Topic.where(:id => params[:topic_id], :forum_id => params[:forum_id]).visible.first
  end

end
