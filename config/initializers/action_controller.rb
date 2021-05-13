ActionController::API.class_eval do
  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
