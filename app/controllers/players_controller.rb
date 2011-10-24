class PlayersController < ApplicationController

  authorize_resource
  cache_sweeper :player_sweeper
  # GET /players
  # GET /players.xml
  def index
    @players = Player.alphabetical
    @page = "Players"
    @description = "Find out about your favorite players in the SC2SL"
    @keywords += ["players"]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    if params[:id].to_i != 0
      @player = Player.find(params[:id].to_i)
    else
      user = User.find_by_login(params[:id])
      unless user
        raise ActionController::RoutingError.new('Not Found')
      end
      @player = user.player
    end
    @comment = Comment.new_of_type(@player)
    @current_page = (params[:page]|| 1).to_i
    @comments_count = @player.comments.count
    @per_page = 10
    @comments= @player.comments.paginated(@per_page, @current_page)
    @page = "Players"
    @subpage = @player.team.to_s + " " + @player.to_s
    @description = "Get all the information on your favorite players."
    @keywords += ["players", @player, @player.team]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])
    if params[:user_id] and Player.find_by_user_id(params[:user_id]) and Player.find_by_user_id(params[:user_id]).active?
      flash[:warning] = "That User already is on a team. Please remove that user before you create a new one."
      render :action => "new"
    else
      if @player.save
        redirect_to(@player, :notice => 'Player was successfully created.') 
      else
        render :action => "new"
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end
