# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
p '--------User--------'
user = User.create!(name: 'Muhammed', password: 'pswd', email: 'compose2uk@gmail.com')

p '--------movie--------'
movie = Movie.create!(title: 'Super Man')


p '--------Screen--------'
screen = Screen.create!(name: 'Aries Plex', total_seats: 100)

p '--------screen seats--------'

30.times { |n| screen.screen_seats.create!(seat_type: 'first class', seat_number: "A-#{n+1}", price: 300) }
40.times { |n| screen.screen_seats.create!(seat_type: 'second class', seat_number: "B-#{n+1}", price: 200) }
30.times { |n| screen.screen_seats.create!(seat_type: 'third class', seat_number: "C-#{n+1}", price: 150) }


p '--------shows--------'
#matinee: '12-3',
#     evening_show: '4-7',
#     second_show: '8-11'
Show.create(movie: movie, screen: screen, timeslot: '12-3')
Show.create(movie: movie, screen: screen, timeslot: '4-7')
Show.create(movie: movie, screen: screen, timeslot: '8-11')




