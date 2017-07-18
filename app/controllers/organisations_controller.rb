class OrganisationsController < ApplicationController
  before_action -> {(render({json: {message: 'Unauthorized Access'}}) and return) unless current_user.superadmin}

  def index
    render json: Organisation.all
  end

  def create
    org = Organisation.new(name: params[:name])
    if org.save
      render json: {success: true, message: 'Organisation created successfully.'}
    else
      render json: {success: false, message: 'There was a problem creating organisation.', error: 'Something went wrong'}
    end
  end

end
