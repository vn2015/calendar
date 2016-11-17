class ReportsController < ApplicationController
  before_filter :authenticate_user!

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
    events = weekly_activity_data
    pdf.instance_eval do
      @events = events
      eval(template) #this evaluates the template with your variables
    end
    attachment = pdf.render
    UserMailer.report_email(attachment,current_user.email_report).deliver_now

    flash.notice = "Email sended"
    redirect_to reports_path
  end


  def weekly_activity_data
      @events = Event
      @start = params[:start]
      @end = params[:end]
      date_end = @end.to_date+1.days
      date_end = date_end.strftime('%Y-%m-%d')

      sql = 'Select c.first_name || \' \'|| c.last_name as client_name, sum(round((extract(epoch from "end" - start)/3600)::numeric,2)) as total_hours '+
          'from events e INNER JOIN clients c ON e.client_id=c.id'+
          ' WHERE e.start>=\''+@start+'\'  and e."end"<=\''+date_end+'\' GROUP BY e.client_id, c.first_name, c.last_name'
      @events = ActiveRecord::Base.connection.execute(sql)

      return @events

  end


end
