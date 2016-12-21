class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /events
  # GET /events.json
  def index

    @events = SelectEventsData()
    @events = @events.where('date_start>=? and "date_end" <=? ', params[:start], params[:end])
    @events =  @events.where('user_events.user_id = ?',current_user.id) if !IsAdmin?
    @events =  @events.where('user_events.user_id = ?',params[:client_id]) if params[:client_id].present?
    @events =  @events.where('events.program_id = ?',params[:program_id]) if params[:program_id].present?
    @events = GroupEventsData(@events)

    @client_total_hours = Event.select("sum(user_events.hours) as hours, sum (user_events.earnings) as earnings ").joins("LEFT JOIN user_events ON user_events.event_id = events.id")
    @client_total_hours = @client_total_hours.where('user_events.user_id = ?',params[:client_id])
    @client_total_hours = @client_total_hours.where('date_start>=? and "date_end" <? ', params[:start], params[:end])

    @total_hours = 0
    @total_earnings = 0
    if params[:client_id].present?
      @total = @client_total_hours.all()
      @total_hours=@total[0][:hours]
      @total_earnings=@total[0][:earnings]
    end

    @events = @events.all.order(:id)
    @programs = Program.all.order(:name)
    @event = Event.new
    @clients = getUser.all
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

    if check_interval>0
      buffer_time =getBufferTime
      render :json => { :errors => "Cannot Book, buffer time of about #{buffer_time} minutes between meetings!"}, status: :no and return
    end
    @event = Event.new(event_params)



    respond_to do |format|
      if @event.save

        event_id = @event.id
        params[:event][:client_id].each do |user|
          ue =UserEvent.new
          ue.user_id =user
          ue.event_id = @event.id
          ue.save
        end

        @event = SelectEventsData()
        @event = GroupEventsData(@event)
        @event = @event.find(event_id)

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def confirm
    @event =UserEvent.where('event_id= ? and user_id= ?',params[:event][:id],current_user.id).first
    if !@event.nil?
      @event.is_confirmed = true
      @event.date_confirmed = Time.now.strftime('%Y-%m-%d %I:%M %p')
      @event.save
    end
    count_hours

    @event = SelectEventsData()
    @event = GroupEventsData(@event)
    @event = @event.find(params[:event][:id])

  end

  def repeat
    #@event =Event.select("events.*, color, array_agg(users.id) client_id").joins(:program).joins("LEFT JOIN user_events ON user_events.event_id = events.id LEFT JOIN users ON users.id = user_events.user_id").group('events.id, programs.color').find(params[:event][:id])
    @event = SelectEventsData()
    @event = GroupEventsData(@event)
    @event = @event.find(params[:event][:id])

    first_event = @event
    repeat_period = params[:event][:repeat_period]
    repeat_quantity = params[:event][:repeat_quantity].to_i

    start_date=params[:event][:start].to_datetime
    end_date=params[:event][:end].to_datetime
    date_finish = params[:event][:start].to_datetime+10.years
    date_finish = params[:event][:repeat_end].to_datetime if params[:event][:repeat_end].present?


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

      if start_date>date_finish
          break
      end

      if check_interval(start_date,end_date,params[:event][:client_id]) === 0
        event_params1= {
          title: params[:event][:title],
          start: start_date,
          end: end_date,
          meetingtype_id: params[:event][:meetingtype_id],
          program_id: params[:event][:program_id],
          address: params[:event][:address],
          transport: params[:event][:transport],
          notes: params[:event][:notes],
          launch_break: params[:event][:launch_break]
        }
        @event = Event.new(event_params1)
        @event.save

        params[:event][:client_id].each do |user|
          ue =UserEvent.new
          ue.user_id =user
          ue.event_id = @event.id
          ue.save
        end

      end

   end
   @event = first_event
   count_hours

   respond_to do |format|
      format.json { render :show, status: :created, location: @event }
   end
  end


  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    #if check_interval>0
    #  render :json => { :errors => "Cannot Book, buffer time of about #{current_user.buffer_time} minutes between meetings!"}, status: :no and return
    #end

    respond_to do |format|
      if @event.update(event_params)

        event_id = @event.id
        @event.user_events.destroy_all

        params[:event][:client_id].each do |user|
          ue =UserEvent.new
          ue.user_id =user
          ue.event_id = @event.id
          ue.save
        end
        count_hours
        #@event = Event.select("events.*, color, array_agg(users.id) client_id").joins(:program).joins("LEFT JOIN user_events ON user_events.event_id = events.id LEFT JOIN users ON users.id = user_events.user_id").group('events.id, programs.color').find(@event.id)
        @event = SelectEventsData()
        @event = GroupEventsData(@event)
        @event = @event.find(event_id)

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
      params.require(:event).permit(:title, :start, :end, :transport, :address,  :program_id, :meetingtype_id, :notes, :launch_break)
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


      buffer_time = getBufferTime
      date_end = date_end + buffer_time.minutes
      date_end= date_end.strftime('%Y-%m-%d %I:%M %p')
      date_start= date_start.strftime('%Y-%m-%d %I:%M %p')
      count_cross_events = Event.joins("LEFT JOIN user_events ON user_events.event_id = events.id LEFT JOIN users ON users.id = user_events.user_id").where('start<=? and "end" >? and user_id in( ?) ',date_end,date_start,client_id)
      count_cross_events = count_cross_events.where('id <> ?',params[:id]) if params[:id].present?
      count_cross_events = count_cross_events.count
      if count_cross_events ===0
        if date_start_orig===''
          date_start = params[:event][:start].to_datetime
        else
          date_start = date_start_orig
        end
        date_start = date_start - buffer_time.minutes
        date_start= date_start.strftime('%Y-%m-%d %I:%M %p')
        count_cross_events = Event.joins("LEFT JOIN user_events ON user_events.event_id = events.id LEFT JOIN users ON users.id = user_events.user_id").where(' start<=? and "end" >=? and user_id  in(?) ',date_start,date_start,client_id)
        count_cross_events = count_cross_events.where('id <> ?',params[:id]) if params[:id].present?
        count_cross_events = count_cross_events.count
      end
      return count_cross_events.to_i

    end

    def count_hours
#      params[:event][:client_id].each do |user|
#        total_hours = UserEvent.select("sum(hours) as hours, sum(earnings) as earnings ").where('user_id=?',user)
#        client = User.find(user)
#        client.hours = total_hours[0]["hours"]
#        client.earnings = total_hours[0]["earnings"]
#        client.save
#      end
        total_hours = UserEvent.select("sum(hours) as hours, sum(earnings) as earnings ").where('user_id=?',current_user.id)
        client = User.find(current_user.id)
        client.hours = total_hours[0]["hours"]
        client.earnings = total_hours[0]["earnings"]
        client.save
    end

   def SelectEventsData
     @events = Event.select("events.*, color, array_agg(users.id) client_id, programs.name as program_name, user_events.hours, user_events.earnings, user_events.hourly_rate,user_events.is_paid,user_events.is_confirmed,user_events.date_confirmed,meetingtypes.name as meetingtype_name ").joins(:program)
     @events = @events.joins("LEFT JOIN user_events ON user_events.event_id = events.id LEFT JOIN users ON users.id = user_events.user_id")
     @events = @events.joins(:meetingtype)
     return @events
   end

   def GroupEventsData(event)
     return event.group('events.id, programs.color,programs.name, user_events.hours, user_events.earnings, user_events.hourly_rate, user_events.is_paid,is_confirmed,user_events.date_confirmed,meetingtypes.name')
   end


end
