class ProgramsController < ApplicationController
  before_action :CheckAccess?
  before_action :set_program, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /programs
  # GET /programs.json
  def index
    @filter_name_val =''
    @is_paid_all = false
    @is_paid_yes =false
    @is_paid_no =false

    if params[:filter_is_paid].present?
      @is_paid_all = true if params[:filter_is_paid]=="all"
      @is_paid_yes = true if params[:filter_is_paid]=="1"
      @is_paid_no = true if params[:filter_is_paid]=="0"

    end
    @filter_name_val =params[:filter_name] if params[:filter_name].present?
    @programs = Program
    @programs =@programs.where("name like '%#{params[:filter_name]}%'") if params[:filter_name].present?
    if !@is_paid_all==true && params[:filter_is_paid].present?
      @programs =@programs.where("COALESCE(is_paid,0) =#{params[:filter_is_paid]}",)
    end
    @programs = @programs.paginate(:page => params[:page]).order(:id).all

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
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to programs_path(request.query_parameters), notice: 'Program was successfully updated.' }
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
