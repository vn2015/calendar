# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create({ :username => "Admin", :is_admin=>true,
              :email => "admin@admin.com",
              :password =>"1q2w3e4r",
              :password_confirmation =>"1q2w3e4r",
              :first_name =>"Admin",
              :last_name =>"Admin"
            })
#Setting.create ({:buffer_time =>30, :email_report =>'nnedogarko@yandex.ru'})
Setting.create ({:buffer_time =>30, :email_report =>'info@aegeanvacation.com'})
Program.create ({:name =>'iWorx', :color =>'#009aff'})
Program.create ({:name =>'Angus Test', :color =>'#ff0062'})
Program.create ({:name =>'Playdough SE', :color =>'#edb900'})
Program.create ({:name =>'George Mentoring', :color =>'#1d0ecc'})
Program.create ({:name =>'Lauren Art', :color =>'#672de3'})
Program.create ({:name =>'Eman D&A', :color =>'#b82563'})
Program.create ({:name =>'Connect', :color =>'#36cc10'})
Program.create ({:name =>'Sick', :color =>'#8a5778'})