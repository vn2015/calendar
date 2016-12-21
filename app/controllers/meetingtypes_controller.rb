class MeetingtypesController < ApplicationController

  before_action :CheckAccess?
  before_action :set_meetingtype, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /meetingtypes
  # GET /meetingtypes.json
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


    @meetingtypes = Meetingtype
    @meetingtypes = @meetingtypes.where("name ilike '%#{params[:filter_name]}%'") if params[:filter_name].present?
    @meetingtypes=@meetingtypes.paginate(:page => params[:page]).all()
    @filter_name_val =params[:filter_name] if params[:filter_name].present?
  end

  # GET /meetingtypes/1
  # GET /meetingtypes/1.json
  def show
  end

  # GET /meetingtypes/new
  def new
    @meetingtype = Meetingtype.new
    @url = meetingtypes_path
  end

  # GET /meetingtypes/1/edit
  def edit
    @url =meetingtype_path(@meetingtype, request.query_parameters)
  end

  # POST /meetingtypes
  # POST /meetingtypes.json
  def create
    @meetingtype = Meetingtype.new(meetingtype_params)

    respond_to do |format|
      if @meetingtype.save
        format.html { redirect_to meetingtypes_path, notice: 'Meetingtype was successfully created.' }
        format.json { render :show, status: :created, location: @meetingtype }
      else
        format.html { render :new }
        format.json { render json: @meetingtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetingtypes/1
  # PATCH/PUT /meetingtypes/1.json
  def update
    respond_to do |format|
      if @meetingtype.update(meetingtype_params)
        flash[:notice] = 'Meeting type was successfully updated.'
        format.html { redirect_to  :controller => "meetingtypes", :action => "index", :params => request.query_parameters }
        #format.html { redirect_to meetingtypes_path, notice: 'Meetingtype was successfully updated.' }
        format.json { render :show, status: :ok, location: @meetingtype }
      else
        format.html { render :edit }
        format.json { render json: @meetingtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetingtypes/1
  # DELETE /meetingtypes/1.json
  def destroy
      @meetingtype.destroy
      respond_to do |format|
        format.html { redirect_to meetingtypes_url, notice: 'Meetingtype was successfully deleted.' }
        format.json { head :no_content }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meetingtype
      @meetingtype = Meetingtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meetingtype_params
      params.require(:meetingtype).permit(:name)
    end
end
