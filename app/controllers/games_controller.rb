class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  authorize_resource
  cache_sweeper :game_sweeper
  def index
    @games = Game.where("games.result is not null")
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
    @current_page = (params[:page].to_i || 0)
    @comments_count = @game.comments.count
    @per_page = 10
    @comments= @game.comments.paginated(@per_page, @current_page)
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
    @game.downloads += 1
    @game.save
    send_file @game.replay.path, :disposition => 'attachment'
  end

  def rate
    @game = Game.find(params[:id])
    @game.rate(params[:stars], current_user)
    respond_to do |format|
      format.js
    end
  end


end
