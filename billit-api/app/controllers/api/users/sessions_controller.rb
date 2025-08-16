class Api::Users::SessionsController < Devise::SessionsController
  respond_to :json

  before_action :log_params
  before_action :remove_session_param, only: [:create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def log_params
    Rails.logger.info("PARAMS: #{params.inspect}")
  end

  def remove_session_param
    params.delete(:session)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def respond_with(resource, _opts = {})
    token = request.env['warden-jwt_auth.token']
    if resource.present? && resource.id.present? && token.present?
      render json: {
        message: 'Logged in successfully',
        token: token,
        user: resource
      }, status: :ok
    else
      render json: {
        error: 'Invalid credentials',
        message: 'Authentication failed'
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    head :no_content
  end
end
