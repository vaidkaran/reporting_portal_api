class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :configure_org_user_permitted_params, if: :resource_class_org_user?

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def configure_org_user_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organisation_id])
  end

  def resource_class_org_user?
    resource_class == OrgUser
  end
end
