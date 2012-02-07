class MatchesController < ApplicationController

    authorize_resource
    cache_sweeper :match_sweeper


  # GET /matches
  # GET /matches.xml
  def index
    @today = Date.today
	@matches_date = (params[:calendar_month] and params[:calendar_year]) ? Date.new(params[:calendar_year].to_i,params[:calendar_month].to_i, 1) : Date.today
	@matches = Match.where(:scheduled_at => (@calendar_date.beginning_of_month - 1)..(@calendar_date.end_of_month + 1)).includes([:team0, :team1]).order("scheduled_at ASC")
 

    @layout_page = "Calendar"
    @description = "See the latest matches"

    @keywords += ["matches", @matches_date.strftime("%B"), @matches_date.year.to_s]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id], :include => [:games, {:team0 => :players}, {:team1 => :players}, :vote_events])
    @comment = Comment.new_of_type(@match)
    @current_page = [(params[:page]|| 1).to_i, 1].max
    @comments_count = @match.comments.count
    @comments= @match.comments.paginated(@current_page, 10)
    @layout_page = "Matches"
    @layout_subpage = @match.title
    @description = "Get the details about this match"
	if @match.team0 and @match.team1
    @keywords += ["matches", @match.team0, @match.team1] + @match.team0.players + @match.team1.players
    else
	  @keywords += ["matches", "tbd"]
	end
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
        format.html { render(:action => "edit" , :notice => 'Match was successfully updated.') }
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
