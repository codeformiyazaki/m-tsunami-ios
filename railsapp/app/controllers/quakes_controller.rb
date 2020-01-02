class QuakesController < ApplicationController
  before_action :set_quake, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, except: [:create]
  protect_from_forgery :except => [:create]

  # GET /quakes
  # GET /quakes.json
  def index
    @quakes = Quake.all.order("created_at desc")
  end

  # GET /quakes/1
  # GET /quakes/1.json
  def show
  end

  # GET /quakes/new
  def new
    @quake = Quake.new
  end

  # GET /quakes/1/edit
  def edit
  end

  # POST /quakes
  # POST /quakes.json
  def create
    @quake = Quake.new(quake_params)
    d = @quake.device
    respond_to do |format|
      if d.nil?
        format.json { render json: "device not found. id=#{@quake.device_id}", status: :unprocessable_entity }
      elsif d.token == params[:token]
        format.json { render json: "token not match. id=#{@quake.device_id}", status: :unprocessable_entity }
      elsif @quake.save
        format.html { redirect_to @quake, notice: 'Quake was successfully created.' }
        format.json { render :show, status: :created, location: @quake }
        send_notify if Quake.happen?
      else
        format.html { render :new }
        format.json { render json: @quake.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quakes/1
  # PATCH/PUT /quakes/1.json
  def update
    respond_to do |format|
      if @quake.update(quake_params)
        format.html { redirect_to @quake, notice: 'Quake was successfully updated.' }
        format.json { render :show, status: :ok, location: @quake }
      else
        format.html { render :edit }
        format.json { render json: @quake.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quakes/1
  # DELETE /quakes/1.json
  def destroy
    @quake.destroy
    respond_to do |format|
      format.html { redirect_to quakes_url, notice: 'Quake was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def test_quake
    # TODO 最終的には実際の地震を起こした感じでテストしたい
    begin
      send_notify("test")
    rescue => e
      @error = e.message
    end
  end

  private
    def send_notify(purpose="test")
      require './lib/tasks/notifier.rb'
      n = Notifier.new
      n.dry_run = false
      @tokens = ApnToken.where("purpose = '#{purpose}'")
      message = "地震発生を検知しました！"
      n.push(@tokens,message)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_quake
      @quake = Quake.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quake_params
      params.require(:quake).permit(:device_id, :elapsed, :p, :s)
    end
end
