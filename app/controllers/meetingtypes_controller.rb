class MeetingtypesController < ApplicationController
  before_action :set_meetingtype, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /meetingtypes
  # GET /meetingtypes.json
  def index
    @meetingtypes = Meetingtype.all.paginate(:page => params[:page])
  end

  # GET /meetingtypes/1
  # GET /meetingtypes/1.json
  def show
  end

  # GET /meetingtypes/new
  def new
    @meetingtype = Meetingtype.new
  end

  # GET /meetingtypes/1/edit
  def edit
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
        format.html { redirect_to meetingtypes_path, notice: 'Meetingtype was successfully updated.' }
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

    event_count = @meetingtype.events.count
    if event_count > 0
      redirect_to meetingtypes_url, alert: 'Can\'t delete, meeting type has events.'
    else
      @meetingtype.destroy
      respond_to do |format|
        format.html { redirect_to meetingtypes_url, notice: 'Meetingtype was successfully destroyed.' }
        format.json { head :no_content }
      end
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
