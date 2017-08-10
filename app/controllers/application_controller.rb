class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ApplicationHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :check_for_superadmin_and_admin, if: :resource_class_org_user?

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def configure_org_user_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organisation_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:organisation_id])
  end

  # Allow special access to superadmin and admin
  # Permit params accordingly
  def check_for_superadmin_and_admin
    # Don't do anything for routes that don't require the user to be superadmin/admin
    return if(resource_class==OrgUser and
              (request[:controller]=='devise_token_auth/sessions') || (request[:controller]=='devise_token_auth/token_validations') and
              (request[:action]=='create') || (request[:action]=='validate_token'))

    devise_parameter_sanitizer.permit(:sign_up, keys: [:organisation_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:organisation_id])

    if !current_user.nil?
      if current_user.superadmin
        configure_org_user_permitted_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
        devise_parameter_sanitizer.permit(:account_update, keys: [:admin])
      else
        render json: {error: 'You don\'t have access to do this'}, status: 403 and return
      end
    elsif !current_org_user.nil?
      if current_org_user.admin
        # An admin_org user can create an org_user only within it's organisation.
        # Setting the organisation_id expicitly to what is the org_user admins'
        params['organisation_id'] = current_org_user.organisation_id
      else
        render json: {error: 'You don\'t have access to do this'}, status: 403 and return
      end
    else
      render json: {error: 'Unauthorized'}, status: 401 and return
    end
  end

  def resource_class_org_user?
    if devise_controller?
      resource_class == OrgUser
    else
      return false
    end
  end

end
