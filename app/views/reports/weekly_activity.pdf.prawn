    pdf = Prawn::Document.new()
    pdf.text "Activity report from #{@start} to #{@end}",:size => 16
    pdf.move_down(20)
    pdf.text "Client Activity",:size => 14
    client_headers = ['#','Clent name','Hours']
    program_headers = ['#','Program name','Hours']

    i=0
    data =@clients.collect{ |p| [ i=i+1, p["client_name"], p["total_hours"] ]}

     pdf.table([client_headers]+data, :header => true) do
        column(0).width=40
        column(0).style(:align => :center)
        column(1).width=345
        column(2).width=150
        column(2).style(:align => :right)
        style row(0),  :background_color => "DDDDDD", :font_style => :bold
     end
     pdf.move_down(10)
     pdf.text "Program Activity",:size => 14
     data =@programs.collect{ |p| [ i=i+1, p["name"], p["total_hours"] ]}
     pdf.table([program_headers]+data, :header => true) do
            column(0).width=40
            column(0).style(:align => :center)
            column(1).width=345
            column(2).width=150
            column(2).style(:align => :right)
            style row(0),  :background_color => "DDDDDD", :font_style => :bold
     end
     pdf.move_down(10)

     pdf.text "Detail Activity",:size => 14


    client = 0

    i=0
    data1=[[],[]]
    @client_programs.each do |cp|
        if client!=cp["id"]
            if i>0
                pdf.table(data1,:column_widths =>[40,345,150]) do
                    column(0).style(:align => :center)
                    column(2).style(:align => :right)
                    style row(0),  :background_color => "DDDDDD", :font_style => :bold
                end
                data1=[[],[]]
                i=0
            end

            data1[i] = ['#',cp["client_name"],'Hours']
            i=i+1
            data1[i] = [i, cp["name"],cp["total_hours"]]
            client =cp["id"]
        else
            i=i+1
            data1[i] = [i, cp["name"],cp["total_hours"]]
        end
    end

    if i>0
        pdf.table(data1,:column_widths =>[40,345,150]) do
            column(0).style(:align => :center)
            column(2).style(:align => :right)
            style row(0),  :background_color => "DDDDDD", :font_style => :bold
        end
    end

     pdf.render