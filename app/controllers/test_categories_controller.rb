class TestCategoriesController < ApplicationController
  # Make sure to handle authentication inside the action methods

  def index
    if current_user
      project = current_user.projects.find(project_id)
      test_categories = project.test_categories
      render json: test_categories, include: :reports
      return
    elsif current_org_user
      if current_org_user.admin
        project = current_org_user.organisation.projects.find(project_id)
        test_categories = project.test_categories
        render json: test_categories, include: :reports
        return
      else
        project = current_org_user.projects.find(project_id)
        test_categories = project.test_categories
        render json: test_categories, include: :reports
        return
      end
    else
      render unauthorized_json and return
    end
  end

  def create
    if current_user
      project = current_user.projects.find(project_id)
      test_category = project.test_categories.new(test_category_params)
      if test_category.save
        render json: test_category
      else
        render json: {message: 'Something went wrong. Could not create test category'}, code: 500
      end
    elsif current_org_user and current_org_user.admin
      project = current_org_user.organisation.projects.find(project_id)
      test_category = project.test_categories.new(test_category_params)
      if test_category.save
        render json: test_category
      else
        render json: {message: 'Something went wrong. Could not create test category'}, code: 500
      end
    else
      render unauthorized_json and return
    end
  end

  private
  def test_category_params
    params.permit :name
  end

  def project_id
    params[:project_id]
  end

  def unauthorized_json
    {json: {"errors":["You need to sign in or sign up before continuing."]}, code: 401}
  end
end
