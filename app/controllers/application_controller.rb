class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    Rails.logger.error("#{e.class}: #{e.message}")

    render json: {
      error: "Internal Server Error"
    }, status: :internal_server_error
  end
end
