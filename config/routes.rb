Rails.application.routes.draw do
  devise_for :users
  resources :questions,
            controller: 'topics',
            only: [:index, :show, :new, :create]
  root 'topics#index'
end
