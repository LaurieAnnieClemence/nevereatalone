class ApplicationController < ActionController::Base
  helper_method :current_user

  check_authorization unless: :admin_controller?

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: "Tu ne peux pas faire ça"
  end

  private

  def current_user
    return unless session[:user_id].present?

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_admin_user
    return unless current_user && current_user.admin?
    current_user
  end

  def authenticate_admin_user!
    unless current_user && current_user.admin?
      redirect_to root_url, alert: "Vous n'êtes pas administrateur"
    end
  end

  def admin_controller?
    request.path.starts_with?("/admin")
  end
end
