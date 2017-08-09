class ProjectsController < ApplicationController
  # Make sure to handle authentication inside the action methods

  def index
    if current_user
      render json: current_user.projects, include: {test_categories: {include: :reports}}
      return
    elsif current_org_user
      if current_org_user.admin
        render json: current_org_user.organisation.projects, include: {test_categories: {include: :reports}}
        return
      else
        render json: current_org_user.projects, include: {test_categories: {include: :reports}}
        return
      end
    else
      render unauthorized_json and return
    end
  end

  def create
    if current_user
      project = current_user.projects.new(project_params)
      if project.save
        render json: project
      else
        render json: {message: 'Something went wrong. Could not create project'}, code: 500
      end
    elsif current_org_user and current_org_user.admin
      project = current_org_user.organisation.projects.new(project_params)
      if project.save
        render json: project
      else
        render json: {message: 'Something went wrong. Could not create project'}, code: 500
      end
    else
      render unauthorized_json and return
    end
  end

  private
  def project_params
    params.permit :name
  end

  def unauthorized_json
    {json: {"errors":["You need to sign in or sign up before continuing."]}, code: 401}
  end
end
