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
end