Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/auth/github/callback', to: 'sessions#github'
  delete '/sign_out', to: 'sessions#destroy', as: :signout
  post '/webhooks/github', to: 'webhooks#github'
  get '/sign_up' => 'users#new', as: 'user_sign_up'
  get '/confirm_email/:token' => 'email_confirmations#confirm', as: 'confirm_email'
  resources :users
  resources :teams do
    resources :projects do
      resource :project_settings, only: %i(edit update), path: :settings

      resources :releases, only: %i(index edit update)
    end
  end
  resource :dashboard, only: %i(show)
  root 'home#index'
end
