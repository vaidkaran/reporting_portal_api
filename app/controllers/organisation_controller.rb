class OrganisationController < ApplicationController
  #before_action -> {(render({json: {message: 'Unauthorized Access'}}) and return) unless current_user.superadmin}

  #def create
  #  org = Organisation.new(name: params[:name])
  #  if org.save
  #    render json: {message: 'Organisation created successfully.'}
  #  else
  #    render json: {message: 'There was a problem creating organisation.', error: 'Something went wrong'}
  #  end
  #end

end
