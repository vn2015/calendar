class ProgramsController < ApplicationController
  before_action :CheckAccess?
  before_action :set_program, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /programs
  # GET /programs.json
  def index
    @filter_name_val =''
    @filter_notes_val =''
    @filter_is_paid = ''
    @button_search_text=''
    @button_search_data=''


    @filter_is_paid = params[:filter_is_paid] if params[:filter_is_paid].present?
    @filter_name_val =params[:filter_name] if params[:filter_name].present?
    @filter_notes_val =params[:filter_notes] if params[:filter_notes].present?
    if params[:commit].present?
      @display = ''
      @button_search_text='Hide Search'
      @button_search_data='open'
    else
      @display = 'display: none;'
      @button_search_text='Show Search'
      @button_search_data='close'
    end

    @programs = Program
    @programs =@programs.where("name ilike '%#{params[:filter_name]}%'") if params[:filter_name].present?
    @programs =@programs.where("notes ilike '%#{params[:filter_notes]}%'") if params[:filter_notes].present?
    if @filter_is_paid!='' && params[:filter_is_paid].present?
      @programs =@programs.where("COALESCE(is_paid,0) =#{@filter_is_paid}",)
    end
    @programs = @programs.paginate(:page => params[:page]).order(:id).all()

    @statuses = [{"name"=>"All", "id"=>""}, {"name"=>"Yes", "id"=>"1"}, {"name"=>"No", "id"=>"0"}]

  end

  # GET /programs/1
  # GET /programs/1.json
  def show
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit

  end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to programs_path, notice: 'Program was successfully created.' }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    logger.debug request.query_parameters
    respond_to do |format|
      if @program.update(program_params)
        flash[:notice] = 'Program was successfully updated.'
        format.html { redirect_to  :controller => "programs", :action => "index", :params => request.query_parameters}
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
      @program.destroy
      respond_to do |format|
        format.html { redirect_to programs_url, notice: 'Program was successfully deleted.' }
        format.json { head :no_content }
      end
  end

  def paid_status_history
    @history = ProgramStatusHistory.where('program_id=?',params[:program_id]).order(:created_at)
    render :layout => false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_params
      params.require(:program).permit(:name, :color, :notes, :is_paid)
    end
end
