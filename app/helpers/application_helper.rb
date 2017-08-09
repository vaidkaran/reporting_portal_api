module ApplicationHelper
  def ensure_authenticated
    unless current_user||current_org_user
      render json: {error: 'Unauthorized'}, status: 401 and return
    end
  end
end
