class TeamsController < ApplicationController
   authorize_resource
   cache_sweeper :team_sweeper
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.all
    @page = "Teams"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.includes({:players => :user}, :comments).find_by_name!(Team.deslug(params[:name]))
    @comment = Comment.new_of_type(@team)
    @current_page = [(params[:page]|| 1).to_i, 1].max
    @comments_count = @team.comments.count
    @comments= @team.comments.paginated(@current_page, 10)
    @layout_page = "Teams"
    @layout_subpage = @team.to_s
    @keywords += ["teams", @team, @team.short_name]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to(team_path(@team.slug), :notice => 'Team was successfully created.') }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to(team_path(@team.slug), :notice => 'Team was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end
end
