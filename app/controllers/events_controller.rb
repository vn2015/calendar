class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @programs = Program.all
    @event = Event.new
    @clients = Client.all
    @meetingtypes = Meetingtype.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @programs = Program.all
    @clients = Client.all
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    if check_interval>0
      render :json => { :errors => "Cannot Book, buffer time of about 59 minutes between meetings!"}, status: :no and return
    end
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if check_interval>0
      render :json => { :errors => "Cannot Book, buffer time of about 59 minutes between meetings!"}, status: :no and return
    end

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
        #format.json {render :json => { :errors => check_interval}, status: :no}
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start, :end, :transport, :address, :client_id, :program_id, :meetingtype_id, :notes)
    end

    def check_interval
      date_end = params[:event][:end].to_datetime
      date_start = params[:event][:start].to_datetime
      client_id = params[:event][:client_id]
      event_id =params[:id]

      date_end = date_end + 59.minutes
      date_end= date_end.strftime('%Y-%m-%d %I:%M %p')
      date_start= date_start.strftime('%Y-%m-%d %I:%M %p')
      count_cross_events = Event.where('start<=? and "end" >? and client_id = ? ',date_end,date_start,client_id)
      count_cross_events = count_cross_events.where("id <> ?",params[:id]) if params[:id].present?
      count_cross_events = count_cross_events.count
      if count_cross_events ==0
        date_start = params[:event][:start].to_datetime
        date_start = date_start - 59.minutes
        date_start= date_start.strftime('%Y-%m-%d %I:%M %p')
        count_cross_events = Event.where(' start<=? and "end" >=? and client_id =? ',date_start,date_start,client_id)
        count_cross_events = count_cross_events.where("id <> ?",params[:id]) if params[:id].present?
        count_cross_events = count_cross_events.count
      end
      return count_cross_events

    end

end
