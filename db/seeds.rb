# frozen_string_literal: true

p '--------Seeding started--------'
p '--------Creating User--------'
User.create!(
  name: 'Muhammed',
  password: 'muhammed',
  email: 'compose2uk@gmail.com',
  user_type: 'admin'
)

p '--------Creating Movie--------'
movie = Movie.create!(title: 'Super Man')


p '--------Creating Screen--------'
screen = Screen.create!(name: 'PVR', total_seats: 100)


p '--------Creating Seats for Screen--------'
30.times do |number|
  screen.screen_seats.create!(
    seat_type: 'first class',
    seat_number: "A-#{number + 1}",
    price: 300
  )
end

40.times do |number|
  screen.screen_seats.create!(
    seat_type: 'second class',
    seat_number: "B-#{number + 1}",
    price: 200
  )
end

30.times do |number|
  screen.screen_seats.create!(
    seat_type: 'third class',
    seat_number: "C-#{number + 1}",
    price: 300
  )
end

p '--------Creating Shows--------'
Show.create(movie: movie, screen: screen, timeslot: '12-3')
Show.create(movie: movie, screen: screen, timeslot: '4-7')
Show.create(movie: movie, screen: screen, timeslot: '8-11')

p '--------Seeding completed--------'



