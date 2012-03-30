ActiveAdmin.register Article do
  scope :all, :default => true
  scope :published
  scope :unpublished
  scope :featured
  
  
  index do
    column "Title" do |article|
      link_to article.title, admin_article_path(article)
    end
    column :published
    column :featured
    column :tag_list
    column :summary
    default_actions
  end

  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :title
      f.input :published
	  f.input :published_at
      f.input :featured
      f.input :tag_list
      f.input :photo
    end
    f.inputs "Text" do
      f.input :summary, :input_html => {:rows => 3, :cols => 20}
      f.input :description, :input_html => { :class => "ckeditor" }
	  f.input :featured_description, :input_html => { :class => "ckeditor" }
    end  
    
    f.buttons

  end
  
  controller do
    cache_sweeper :article_sweeper
    def create
      @article = Article.new(params[:article])
	  @article.user = current_user
      create!
    end

    def new
      @article = Article.new
      @article.published_at = Time.now
      new!

    end
    
    
  end
  
  
  

end
