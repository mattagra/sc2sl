class SeasonsController < ApplicationController

   authorize_resource


  # GET /seasons
  # GET /seasons.xml
  def index
    @seasons = Season.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seasons }
    end
  end

  # GET /seasons/1
  # GET /seasons/1.xml
  def show
    @season = Season.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/new
  # GET /seasons/new.xml
  def new
    @season = Season.new
    @season.teams.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/1/edit
  def edit
    @season = Season.find(params[:id])
  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @season = Season.new(params[:season])

    respond_to do |format|
      if @season.save
        schedule_matches(@season, params[:weeks], params[:days], params[:date][:hour], params[:date][:minute])
        add_playoff_matches(@season, params[:num_teams])
        format.html { redirect_to(@season, :notice => 'Season was successfully created.') }
        format.xml  { render :xml => @season, :status => :created, :location => @season }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.xml
  def update
    @season = Season.find(params[:id])

    respond_to do |format|
      if @season.update_attributes(params[:season])
        schedule_matches(@season, params[:weeks], params[:days], params[:date][:hour], params[:date][:minute])
        add_playoff_matches(@season, params[:num_teams])
        format.html { redirect_to(@season, :notice => 'Season was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.xml
  def destroy
    @season = Season.find(params[:id])
    @season.destroy

    respond_to do |format|
      format.html { redirect_to(seasons_url) }
      format.xml  { head :ok }
    end
  end


  private
  def schedule_matches(season, weeks, days, h, m)
    if weeks and weeks.count > 0 and days and days.count > 0
      rules = []
      days.each do |day|
        rules << RRSchedule::Rule.new(:wday => day.to_i, :ps => "1")
      end
      schedule=RRSchedule::Schedule.new(:teams => season.teams.collect{|t| t.id},
        :rules => rules,
        :cycles => 1,
        :shuffle => true
      )
      schedule.generate
      games = schedule.gamedays.collect{ |gd| gd.games }
      maps = season.maps
      w = 1
      weeks.each do |week|
        week_maps = maps.shuffle
        days.each do |day|
          t = Time.now.end_of_week + (week.to_i).week + day.to_i.days + h.to_i.hours + m.to_i.minutes + 1.second
          game = games.shift
          Match.new(:team0_id => game[0].team_a, :team1_id => game[0].team_b, :season_id => season.id, :weeks_id => w, :scheduled_at => t, :best_of => 7, :maps => week_maps).save
        end
        w += 1
      end
    end
  end

  def add_playoff_matches(season, num_teams)
    season.playoff_matches.each {|m| m.destroy}
    maps = season.maps
    num_teams = num_teams.to_i
    if num_teams > 0
    (num_teams).times do |i|
      Match.new(:season_id => season.id, :best_of => 7, :maps => maps, :playoff_id => i).save
    end
    end
  end


end
