class ApnTokensController < ApplicationController
  before_action :set_apn_token, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, except: [:create]

  # GET /apn_tokens
  # GET /apn_tokens.json
  def index
    @apn_tokens = ApnToken.all
  end

  # GET /apn_tokens/1
  # GET /apn_tokens/1.json
  def show
  end

  # GET /apn_tokens/new
  def new
    @apn_token = ApnToken.new
  end

  # GET /apn_tokens/1/edit
  def edit
  end

  # POST /apn_tokens
  # POST /apn_tokens.json
  def create
    @apn_token = ApnToken.new(apn_token_params)

    respond_to do |format|
      if @apn_token.save
        format.html { redirect_to @apn_token, notice: 'Apn token was successfully created.' }
        format.json { render :show, status: :created, location: @apn_token }
      else
        format.html { render :new }
        format.json { render json: @apn_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apn_tokens/1
  # PATCH/PUT /apn_tokens/1.json
  def update
    respond_to do |format|
      if @apn_token.update(apn_token_params)
        format.html { redirect_to @apn_token, notice: 'Apn token was successfully updated.' }
        format.json { render :show, status: :ok, location: @apn_token }
      else
        format.html { render :edit }
        format.json { render json: @apn_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apn_tokens/1
  # DELETE /apn_tokens/1.json
  def destroy
    @apn_token.destroy
    respond_to do |format|
      format.html { redirect_to apn_tokens_url, notice: 'Apn token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apn_token
      @apn_token = ApnToken.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def apn_token_params
      params.require(:apn_token).permit(:token, :type)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "code4miyazaki" && password == ENV["BASIC_AUTH_PASS"]
      end
    end
end
