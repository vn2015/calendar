# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create({ :username => "Admin", :email_report =>"nnedogarko@yandex.ru", :buffer_time=>59,:is_admin=>true, :email => "admin@admin.com", :password =>"1q2w3e4r", :password_confirmation =>"1q2w3e4r"})
Setting.create ({:buffer_time =>30, :email_report =>'nnedogarko@yandex.ru'})