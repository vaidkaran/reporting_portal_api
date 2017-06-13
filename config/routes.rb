Rails.application.routes.draw do
  mount_devise_token_auth_for 'OrganisationalUser', at: 'organisation_auth'

  post 'upload/junit', to: 'upload#junit', as: 'upload_junit'

  resources :reports, only: [:show]

  mount_devise_token_auth_for 'User', at: 'auth'
  as :user do
    # Define routes for User within this block.
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
