ActiveAdmin.register Article do
  scope :all, :default => true
  scope :published
  scope :unpublished
  scope :featured

  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :title
      f.input :published
      f.input :featured
      f.input :tag_list
      f.input :photo
    end
    f.inputs "Text" do
      f.input :summary, :input_html => {:rows => 3, :cols => 20}
      f.input :description, :input_html => { :class => "ckeditor" }
    end  
    
    f.buttons

  end
  
  controller do
    cache_sweeper :article_sweeper
    def create
      @article = Article.new(params[:article])
	  @article.user = current_user
      if @article.save
        flash[:notice] = "Article Created!"
        redirect_to :action => :show, :id => @article.id
      else
	    flash[:warning] = "There was a problem when trying to create an article"
        render :action => :edit
      end
    end
    
  end
  
  
  

end
