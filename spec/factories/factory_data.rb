
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    user_type { 'user' }
    password { SecureRandom.alphanumeric }
  end

  factory :movie do
    title { Faker::Music.album }
  end

  factory :screen do
    name { Faker::University.name }
    total_seats { 100 }
    trait :with_screen_seats do
      after(:create) do |screen, _evaluator|
        30.times do |number|
          create(:screen_seat,
                 screen: screen,
                 seat_type: 'first class',
                 seat_number: "A-#{number+1}",
                 price: 300)
          create(:screen_seat,
                 screen: screen,
                 seat_type: 'second class',
                 seat_number: "B-#{number+1}",
                 price: 200)
          create(:screen_seat,
                 screen: screen,
                 seat_type: 'third class',
                 seat_number: "C-#{number+1}",
                 price: 150)
        end
        (31..40).each do |number|
          create(:screen_seat,
                 screen: screen,
                 seat_type: 'second class',
                 seat_number: "B-#{number}",
                 price: 200)
        end
      end
    end
  end

  factory :screen_seat do
    screen { create(:screen) }
    seat_type { 'first class' }
    seat_number { 'A-1' }
    price { 300 }
  end

  factory :show do
    movie { create(:movie) }
    screen { create(:screen, :with_screen_seats) }
    date { Date.today }
    timeslot { '4-7' }
  end

  factory :show_seat do
    screen_seat { create(:screen_seat) }
    show { create(:show) }
  end

  factory :booking do
    user { create(:user) }
    show { create(:show) }

    transient do
      selected_seats { nil }
    end

    after(:create) do |booking, evaluator|
      timestamp = Time.now
      bulk_seat_params = evaluator.selected_seats.map do |seat|
        {
          booking_id: booking.id,
          screen_seat_id: seat.id,
          created_at: timestamp,
          updated_at: timestamp
        }
      end
      booking.show.show_seats.insert_all!(bulk_seat_params)
    end
  end
end
