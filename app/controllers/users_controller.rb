class UsersController < ApplicationController
  before_action :CheckAccess?
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /users
  # GET /users.json
  def index

    if params[:commit].present?
      @display = ''
      @button_search_text='Hide Search'
      @button_search_data='open'
    else
      @display = 'display: none;'
      @button_search_text='Show Search'
      @button_search_data='close'
    end

    @filter_first_name_val =params[:filter_first_name] if params[:filter_first_name].present?
    @filter_last_name_val =params[:filter_last_name] if params[:filter_last_name].present?
    @filter_notes_val =params[:filter_notes] if params[:filter_notes].present?
    @filter_dob_val =params[:filter_dob] if params[:filter_dob].present?
    @filter_client_id_val =params[:filter_client_id] if params[:filter_client_id].present?
    @filter_rate_val =params[:filter_rate] if params[:filter_rate].present?

    @users = getUser
    @users =@users.where("first_name ilike '%#{params[:filter_first_name]}%'") if params[:filter_first_name].present?
    @users =@users.where("last_name ilike '%#{params[:filter_last_name]}%'") if params[:filter_last_name].present?
    @users =@users.where("notes ilike '%#{params[:filter_notes]}%'") if params[:filter_notes].present?
    @users =@users.where("dob= ?",params[:filter_dob]) if params[:filter_dob].present?
    @users =@users.where("client_id= ?",params[:filter_client_id]) if params[:filter_client_id].present?
    @users =@users.where("hourly_rate =?",params[:filter_rate]) if params[:filter_rate].present?


    @users = @users.paginate(:page => params[:page]).order(:id).all()
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @url =  create_user_path
  end

  # GET /users/1/edit
  def edit
    #@url = user_path(@user.id)
    @url = user_path(@user, request.query_parameters)
  end

  # POST /users
  # POST /users.json
  def create_user
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'user was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = 'User was successfully updated.'
        format.html {redirect_to  :controller => "users", :action => "index", :params => request.query_parameters}
        #format.html { redirect_to users_path, notice: 'user was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'user was successfully deleted.' }
        format.json { head :no_content }
      end
  end

  def hourly_rate_history
    @history = UserRateHistory.where('user_id=?',params[:user_id]).order(:created_at)
    render :layout => false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name,:last_name, :dob, :notes, :user_id,:email, :client_id, :password, :password_confirmation,:hourly_rate)
    end
end
