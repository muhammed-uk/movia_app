# frozen_string_literal: true

module BasicAuthenticator
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user

    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :authenticate_user!, if: :require_authentication?
  end

  protected def check_permission!
    head :unauthorized unless current_user.try(:admin?)
  end

  private

  def authenticate_user!
    authenticate_or_request_with_http_basic do |email, password|
      @current_user = User.find_by(email: email, password: password)
    end
  end

  def require_authentication?
    request.env['HTTP_AUTHORIZATION'].present?
  end
end
