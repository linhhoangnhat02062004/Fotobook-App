class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Cấu hình strong parameters cho Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  # Helper method để logout
  def logout_user
    sign_out(current_user) if user_signed_in?
    redirect_to root_path, notice: 'Logged out successfully.'
  end

  # Devise after sign out path
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # Devise after sign in path
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      feeds_path
    end
  end
end
