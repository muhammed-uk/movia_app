# frozen_string_literal: true

module ApiHelper
  def check_for_instance(instance, class_name, id)
    if instance.nil?
      render json: {
        errors: [
          "Could not identify any #{class_name} with #{id}"
        ]
      }, status: :not_found
    end
  end

  def setup_anonymous_user
    random_string = SecureRandom.alphanumeric
    User.create!(
      name: "user-#{random_string}",
      email: "anonymous#{random_string}@gmail.com",
      password: random_string
    )
  end
end
