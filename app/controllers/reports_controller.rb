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
          ' WHERE e.date_start>=\''+@start+'\'  and e.date_end<=\''+date_end+'\' GROUP BY u.id, u.username'
      @clients = ActiveRecord::Base.connection.execute(sql)

      sql = 'Select p.name, sum(ue.hours) as total_hours, sum(ue.earnings) as total_earnings '+
          'from events e INNER JOIN programs p ON e.program_id=p.id'+
          ' INNER JOIN user_events ue  ON ue.event_id = e.id '+
          ' WHERE e.date_start>=\''+@start+'\'  and e.date_end<=\''+date_end+'\' GROUP BY e.program_id, p.name'
      @programs = ActiveRecord::Base.connection.execute(sql)

      sql = 'Select p.name,u.username as client_name, u.id, sum(ue.hours) as total_hours, sum(ue.earnings) as total_earnings '+
          'from events e INNER JOIN programs p ON e.program_id=p.id'+
          ' INNER JOIN user_events ue  ON ue.event_id = e.id INNER JOIN users u ON u.id = ue.user_id'+
          ' WHERE e.date_start>=\''+@start+'\'  and e.date_end<=\''+date_end+'\' GROUP BY  p.name, u.username, u.id order by u.id'
      @client_programs = ActiveRecord::Base.connection.execute(sql)

      @start = @start.to_date.strftime('%d-%m-%Y')
      @end = @end.to_date.strftime('%d-%m-%Y')


      return ['clients' =>@clients, 'programs' =>@programs, 'client_programs' => @client_programs]

  end


end
