class ReportsController < ApplicationController
  before_action :CheckAccess?
  before_action :authenticate_user!

  def index

  end

  def weekly_activity

    @events = weekly_activity_data
    respond_to do |format|
      format.html # show.html.erb
      format.pdf { render :layout => false}
    end
  end

  def weekly_activity_send

    template = File.read("#{Rails.root}/app/views/reports/weekly_activity.pdf.prawn")
    pdf = Prawn::Document.new
    clients = weekly_activity_data[0]["clients"]
    programs = weekly_activity_data[0]["programs"]
    client_programs = weekly_activity_data[0]["client_programs"]
    start_tmp = params[:start].to_date.strftime('%d-%m-%Y')
    end_tmp = params[:end].to_date.strftime('%d-%m-%Y')


    pdf.instance_eval do
      @clients = clients
      @programs = programs
      @client_programs = client_programs
      @start = start_tmp
      @end = end_tmp
      eval(template) #this evaluates the template with your variables
    end
    attachment = pdf.render
    email_report = getReportEmail
    UserMailer.report_email(attachment,email_report).deliver_now

    flash.notice = "Email sended"
    redirect_to reports_path
  end


  def weekly_activity_data

      @start = params[:start]
      @end = params[:end]
      date_end = @end.to_date+1.days
      date_end = date_end.strftime('%Y-%m-%d')

      sql = 'Select username as client_name, sum(ue.hours) as total_hours, sum(ue.earnings) as total_earnings '+
          'from events e INNER JOIN user_events ue  ON ue.event_id = e.id INNER JOIN users u ON u.id = ue.user_id '+
          ' WHERE e.date_start>=\''+@start+'\'  and e.date_end<=\''+date_end+'\' and ue.is_confirmed = true GROUP BY u.id, u.username'
      @clients = ActiveRecord::Base.connection.execute(sql)

      sql = 'Select p.name, sum(ue.hours) as total_hours, sum(ue.earnings) as total_earnings '+
          'from events e INNER JOIN programs p ON e.program_id=p.id'+
          ' INNER JOIN user_events ue  ON ue.event_id = e.id '+
          ' WHERE e.date_start>=\''+@start+'\'  and e.date_end<=\''+date_end+'\' and ue.is_confirmed = true GROUP BY e.program_id, p.name'
      @programs = ActiveRecord::Base.connection.execute(sql)

      sql = 'Select p.name,u.username as client_name, u.id, sum(ue.hours) as total_hours, sum(ue.earnings) as total_earnings '+
          'from events e INNER JOIN programs p ON e.program_id=p.id'+
          ' INNER JOIN user_events ue  ON ue.event_id = e.id INNER JOIN users u ON u.id = ue.user_id'+
          ' WHERE e.date_start>=\''+@start+'\'  and e.date_end<=\''+date_end+'\' and ue.is_confirmed = true GROUP BY  p.name, u.username, u.id order by u.id'
      @client_programs = ActiveRecord::Base.connection.execute(sql)

      @start = @start.to_date.strftime('%d-%m-%Y')
      @end = @end.to_date.strftime('%d-%m-%Y')


      return ['clients' =>@clients, 'programs' =>@programs, 'client_programs' => @client_programs]

  end


  def events_confirm

    @date_to_val = Time.now.strftime('%Y-%m-%d')
    @date_from_val = (Time.now - 1.months).strftime('%Y-%m-%d')

    @date_to_val = params[:date_to].to_datetime.strftime('%Y-%m-%d') if params[:date_to].present?
    @date_from_val = params[:date_from].to_datetime.strftime('%Y-%m-%d') if params[:date_from].present?

    @client_id = nil
    @client_id = params[:client_id] if params[:client_id].present?

    @program_id = nil
    @program_id = params[:program_id] if params[:program_id].present?

    @is_confirmed = nil
    @is_confirmed = params[:is_confirmed] if params[:is_confirmed].present?


    @events = Event.select("events.title, events.start, events.end, users.first_name, users.last_name, programs.name as program_name, user_events.id as user_events_id, user_events.user_id,  user_events.hours, user_events.earnings, user_events.hourly_rate,user_events.is_paid,user_events.is_confirmed,user_events.date_confirmed ").joins(:program)
    @events = @events.joins("LEFT JOIN user_events ON user_events.event_id = events.id LEFT JOIN users ON users.id = user_events.user_id")
    @events = @events.joins(:meetingtype)
    @events = @events.where('date_start>=? and "date_end" <=? ', @date_from_val, @date_to_val)
    @events = @events.where('program_id =?', @program_id) if params[:program_id].present?
    @events = @events.where('user_id =?', @client_id) if params[:client_id].present?
    @events = @events.where('is_confirmed =?', @is_confirmed)  if params[:is_confirmed].present?
    @events = @events.all()

    @clients = getUser.all()
    @programs = Program.all.order(:name)
  end

  def user_event_confirm
    @user_event = UserEvent.find(params[:user_event_id])
    @user_event.is_confirmed = true
    @user_event.save

    total_hours = UserEvent.select("sum(hours) as hours, sum(earnings) as earnings ").where('user_id=?',@user_event.user_id)
    client = User.find(@user_event.user_id)
    client.hours = total_hours[0]["hours"]
    client.earnings = total_hours[0]["earnings"]
    client.save

    flash[:notice] = 'Event was successfully confirmed.'
    redirect_to  :controller => "reports", :action => "events_confirm", :params => request.query_parameters

  end

end
