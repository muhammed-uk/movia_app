# frozen_string_literal: true

module SupportHelper
  def create_admin_user
    @admin_user = FactoryBot.create(:user, user_type: 'admin')
    credentials = [@admin_user.email, @admin_user.password]
    @admin_headers = generate_headers(credentials)
  end

  def create_normal_user
    @user = FactoryBot.create(:user)
    credentials = [@user.email, @user.password]
    @user_headers = generate_headers(credentials)
  end

  def generate_headers(credentials)
    encoded_basic_auth = ActionController::HttpAuthentication::Basic
                         .encode_credentials(*credentials)
    {
      'ACCEPT' => 'application/json',
      'Authorization' => encoded_basic_auth
    }
  end

  def generate_sample_data
    create_admin_user
    create_normal_user
    create_movies(3)
    create_screen_with_seats(1)
    create_shows(%w[12-3 4-7 8-11], Screen.first, Movie.first)
  end

  def create_movies(number)
    number.times { FactoryBot.create(:movie) }
  end

  def create_screen_with_seats(number)
    number.times { FactoryBot.create(:screen, :with_screen_seats) }
  end

  def create_shows(timeslots, screen, movie)
    timeslots.each do |timeslot|
      create(:show, screen: screen, timeslot: timeslot, movie: movie)
    end
  end

  def create_booking(show, selected_seats, user = nil)
    if user.present?
      create(:booking, show: show, selected_seats: selected_seats, user: user)
    else
      create(:booking, show: show, selected_seats: selected_seats)
    end
  end
end
