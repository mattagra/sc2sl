class MatchesController < ApplicationController

    authorize_resource
cache_sweeper :match_sweeper


  # GET /matches
  # GET /matches.xml
  def index
    if params[:match_id]
    @matches = Match.order("weeks_id asc").where(:match_id => params[:match_id])
    else
    @matches = Match.order("id desc")
    end

    @page = "Matches"
    @description = "See the latest matches"

    @keywords += ["matches"]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id])
    @comment = Comment.new_of_type(@match)
    @current_page = (params[:page] || 1).to_i
    @comments_count = @match.comments.count
    @per_page = 10
    @comments= @match.comments.paginated(@per_page, @current_page)
    @page = "Matches"
    @subpage = @match.title
    @description = "Get the details about this match"
    @keywords += ["matches", @match.team0, @match.team1] + @match.team0.players + @match.team1.players

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.xml
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
    games = @match.games.size
    (7 - games).times do |i|
      @match.games.build(:match_order => games + 1 + i)
    end
  end

  # POST /matches
  # POST /matches.xml
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to(@match, :notice => 'Match was successfully created.') }
        format.xml  { render :xml => @match, :status => :created, :location => @match }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.xml
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to(@match, :notice => 'Match was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
      format.xml  { head :ok }
    end
  end
end
