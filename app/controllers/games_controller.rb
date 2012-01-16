class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  authorize_resource
  cache_sweeper :game_sweeper
  def index
    
    @layout_page = "Replay List"
    @description = "List of all recent replays."
    @keywords += ["games", "replays"]
    @current_page = (params[:page]|| 1).to_i
    @per_page = 20


    if params[:team_id]
      @team = Team.find(params[:team_id])
      @games = @team.games.paginated(@current_page, @per_page)
      @games_count = @team.games.count
      @keywords += [@team.name]
    elsif params[:player_id]
      @player = Player.find(params[:player_id])
      @games = @player.games.paginated(@current_page, @per_page)
      @games_count = @player.games.count
      @keywords += [@player.login]
	elsif params[:matchup]
	  @games = Game.matchup(params[:matchup][:race0], params[:matchup][:race1]).paginated(@current_page, @per_page)
	  @games_count = Game.matchup(params[:matchup][:race0], params[:matchup][:race1]).count
	  @keywords += [params[:matchup][:race0],params[:matchup][:race1] ]
    else
      @games = Game.where("games.result is not null").paginated(@current_page, @per_page)
      @games_count = Game.where("games.result is not null").count
    end


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])
    @comment = Comment.new_of_type(@game)
    @current_page = (params[:page] || 1).to_i
    @comments_count = @game.comments.count
    @comments= @game.comments.paginated(@current_page, 10)
    @layout_page = "Game"
    @layout_subpage = @game.title
    @description = "Find Replays and VODS"
    @keywords += ["games", "replays", "VOD"] + [@game.player0, @game.player1, @game.team0, @game.team1, @game.map]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end




  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end

  def replay
    @game = Game.find(params[:id])
    if current_user
	  if @game.replay
	    @game = Game.find(params[:id])
        @game.downloads += 1
        @game.save
        send_file @game.replay.path, :disposition => 'attachment'
	  else
	    flash[:notice] = "This replay is not yet available for download. Please try again later."
        redirect_to :action => :show, :id => params[:id]
	  end
    else
      flash[:notice] = "You must be registered in order to download replays."
      redirect_to :action => :show, :id => params[:id]
    end
  end

  def rate
    @game = Game.find(params[:id])
    @game.rate(params[:stars], current_user)
    respond_to do |format|
      format.js
    end
  end


end
