class SuperadminSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :only_superadmin_user

  def create_superadmin
    user = User.find_by(email: params[:email])
    if user.nil?
      render json: {error: "Could not find an existing user with the email: #{params[:email]}"}
    else
      if user.update(superadmin: true)
        render json: {message: "User with email: #{params[:email]} is now a superadmin}"}
      else
        render json: {error: "Something went wrong. Could not create superadmin."}
      end
    end
  end

  def destroy_superadmin
    user = User.find_by(email: params[:email])
    if user.nil?
      render json: {error: "Could not find an existing user with the email: #{params[:email]}"}
    else
      if user.update(superadmin: false)
        render json: {message: "User with email: #{params[:email]} is no longer a superadmin}"}
      else
        render json: {error: "Something went wrong. Could not destroy superadmin."}
      end
    end
  end

  private
  def only_superadmin_user
    return current_user.superadmin
  end
end
