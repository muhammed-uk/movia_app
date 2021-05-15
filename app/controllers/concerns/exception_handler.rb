module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |error|
      Rails.logger.error "Error occurred: #{error.message}"
      render json: { errors: ['Oops! Something went wrong.'] }, status: 500
    end
  end
end