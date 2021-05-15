class ApplicationController < ActionController::API
  include ApiHelper
  include ExceptionHandler
  include BasicAuthenticator
end
