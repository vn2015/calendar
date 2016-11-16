class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where('start>=? and "end" <=? ', params[:start], params[:end])
    @events=  @events.where('client_id = ?',params[:client_id]) if params[:client_id].present?
    @events = @events.all
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
        count_hours
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def repeat
    @event = Event.find(params[:event][:id])
    repeat_period = params[:event][:repeat_period]
    repeat_quantity = params[:event][:repeat_quantity].to_i

    start_date=params[:event][:start].to_datetime
    end_date=params[:event][:end].to_datetime

    
    for i in 1..repeat_quantity
      case repeat_period # a_variable is the variable we want to compare
        when "Daily"
          start_date = start_date +1.days
          end_date = end_date +1.days
        when "Weekly"
          start_date = start_date +1.weeks
          end_date = end_date +1.weeks
        when "Monthly"
          start_date = start_date +1.months
          end_date = end_date +1.months
        when "Quarterly"
          start_date = start_date +3.months
          end_date = end_date +3.months
        when "Yearly"
          start_date = start_date +1.years
          end_date = end_date +1.years
      end

      if check_interval(start_date,end_date,params[:event][:client_id]) === 0
        event_params1= {
          title: params[:event][:title],
          start: start_date,
          end: end_date,
          meetingtype_id: params[:event][:meetingtype_id],
          client_id: params[:event][:client_id],
          program_id: params[:event][:program_id],
          address: params[:event][:address],
          transport: params[:event][:transport],
          notes: params[:event][:notes]
        }
        @event = Event.new(event_params1)
        @event.save
      end

    end

    respond_to do |format|
      format.json { render :show, status: :created, location: @event }
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
        count_hours
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
    count_hours
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

    def check_interval(date_start_orig='', date_end_orig='',client_id_orig='')
      if date_start_orig===''
        date_end = params[:event][:end].to_datetime
        date_start = params[:event][:start].to_datetime
        client_id = params[:event][:client_id]
        event_id =params[:id]
      else
        date_end = date_end_orig
        date_start = date_start_orig
        client_id = client_id_orig
      end

      date_end = date_end + 59.minutes
      date_end= date_end.strftime('%Y-%m-%d %I:%M %p')
      date_start= date_start.strftime('%Y-%m-%d %I:%M %p')
      count_cross_events = Event.where('start<=? and "end" >? and client_id = ? ',date_end,date_start,client_id)
      count_cross_events = count_cross_events.where('id <> ?',params[:id]) if params[:id].present?
      count_cross_events = count_cross_events.count
      if count_cross_events ===0
        if date_start_orig===''
          date_start = params[:event][:start].to_datetime
        else
          date_start = date_start_orig
        end
        date_start = date_start - 59.minutes
        date_start= date_start.strftime('%Y-%m-%d %I:%M %p')
        count_cross_events = Event.where(' start<=? and "end" >=? and client_id =? ',date_start,date_start,client_id)
        count_cross_events = count_cross_events.where('id <> ?',params[:id]) if params[:id].present?
        count_cross_events = count_cross_events.count
      end
      return count_cross_events.to_i

    end

    def count_hours
      total_hours = Event.where('client_id=?',params[:event][:client_id]).sum('round((extract(epoch from "end" - start)/3600)::numeric,2)')
      client = Client.find(params[:event][:client_id])
      client.hours=total_hours
      client.save

    end

end
