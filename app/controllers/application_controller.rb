class ApplicationController < ActionController::Base
  before_action :auto_login_if_token

  check_authorization unless: :admin_controller?

  helper_method :current_user

  before_action :redirect_to_main_domain
  before_action :set_paper_trail_whodunnit

  rescue_from ActiveRecord::RecordNotFound do
    render "pages/not_found"
  end

  rescue_from CanCan::AccessDenied do
    redirect_to(
      new_session_path(redirect_to: request.fullpath),
      alert: "Tu as sûrement besoin d'être connecté pour aller sur cette page",
    )
  end

  private

  def auto_login_if_token
    return unless params[:token].present?

    user = User.from_token(params[:token])
    return unless user
    session[:user_id] = user.id
  end

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

  def redirect_to_main_domain
    if request.host_with_port != ENV.fetch("HOST")
      redirect_to "#{request.protocol}#{ENV.fetch("HOST")}#{request.fullpath}"
    end
  end
end
