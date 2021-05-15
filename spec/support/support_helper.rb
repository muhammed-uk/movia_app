# frozen_string_literal: true

module SupportHelper
  def setup_accounts_and_numbers
    @user = FactoryBot.create(:account)
    5.times do |n|
      FactoryBot.create(:phone_number, account: @user)
    end
    credentials = [@user.username, @user.auth_id]
    encoded_basic_auth = ActionController::HttpAuthentication::Basic.encode_credentials(*credentials)
    @headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => encoded_basic_auth
    }
  end

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
end
