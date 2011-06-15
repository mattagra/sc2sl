class GameRatingsController < ApplicationController
  # GET /game_ratings
  # GET /game_ratings.xml
  def index
    @game_ratings = GameRating.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_ratings }
    end
  end

  # GET /game_ratings/1
  # GET /game_ratings/1.xml
  def show
    @game_rating = GameRating.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_rating }
    end
  end

  # GET /game_ratings/new
  # GET /game_ratings/new.xml
  def new
    @game_rating = GameRating.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_rating }
    end
  end

  # GET /game_ratings/1/edit
  def edit
    @game_rating = GameRating.find(params[:id])
  end

  # POST /game_ratings
  # POST /game_ratings.xml
  def create
    @game_rating = GameRating.new(params[:game_rating])

    respond_to do |format|
      if @game_rating.save
        format.html { redirect_to(@game_rating, :notice => 'Game rating was successfully created.') }
        format.xml  { render :xml => @game_rating, :status => :created, :location => @game_rating }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_ratings/1
  # PUT /game_ratings/1.xml
  def update
    @game_rating = GameRating.find(params[:id])

    respond_to do |format|
      if @game_rating.update_attributes(params[:game_rating])
        format.html { redirect_to(@game_rating, :notice => 'Game rating was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_ratings/1
  # DELETE /game_ratings/1.xml
  def destroy
    @game_rating = GameRating.find(params[:id])
    @game_rating.destroy

    respond_to do |format|
      format.html { redirect_to(game_ratings_url) }
      format.xml  { head :ok }
    end
  end
end
