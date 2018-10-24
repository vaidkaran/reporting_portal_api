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

  # Only implemented and tested for independent users
  def show
    if TestCategory.where(id: params[:id]).present?
      tc = TestCategory.find(params[:id])
      if (current_user && current_user==tc.project.user)
        render json: tc
      else
        render unauthorized_json and return
      end
    else
      render test_category_not_found_json
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
    params.permit :name, :report_type, :report_format
  end

  def project_id
    params[:project_id]
  end

  def unauthorized_json
    {json: {"errors":["You need to sign in or sign up before continuing."]}, code: 401}
  end

  def test_category_not_found_json
    {json: {"errors":["Test category not found"]}, code: 404}
  end
end
