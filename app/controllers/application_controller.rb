# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiHelper
  include ExceptionHandler
  include BasicAuthenticator
end
