Rails.application.routes.draw do
  devise_for :users
  resources :questions,
            controller: 'topics',
            only: [:index, :show, :new, :create] do
    resources :answers, controller: 'messages', only: [:create]
  end
  root 'topics#index'
end
