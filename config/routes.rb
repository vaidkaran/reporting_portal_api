Rails.application.routes.draw do
  mount_devise_token_auth_for 'OrgUser', at: 'org_auth'
  #mount_devise_token_auth_for 'OrgUser', at: 'org_auth', controllers: {
  #  registrations: 'org_users/registrations'
  #}


  post 'upload/junit', to: 'upload#junit', as: 'upload_junit'
  post 'upload/mocha', to: 'upload#mocha', as: 'upload_mocha'

  post 'superadmin_settings/create_superadmin', to: 'superadmin_settings#create_superadmin', as: 'create_superadmin'
  post 'superadmin_settings/destroy_superadmin', to: 'superadmin_settings#destroy_superadmin', as: 'destroy_superadmin'

  resources :organisations, except: [:new]
  resources :reports, only: [:show]

  mount_devise_token_auth_for 'User', at: 'auth'
  as :user do
    # Define routes for User within this block.
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
