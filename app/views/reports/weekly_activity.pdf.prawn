    pdf = Prawn::Document.new()
    pdf.text "Clients activity report from #{@start} to #{@end}",:size => 16
    pdf.move_down(30)
    headers = ['#','Clent name','Hours']

    i=0
    data =@events.collect{ |p| [ i=i+1, p["client_name"], p["total_hours"] ]}

     pdf.table([headers]+data, :header => true) do
        column(0).width=40
        column(0).style(:align => :center)
        column(1).width=345
        column(2).width=150
        column(2).style(:align => :right)
        style row(0),  :background_color => "DDDDDD", :font_style => :bold
     end

     pdf.render
