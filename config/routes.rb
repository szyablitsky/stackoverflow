Rails.application.routes.draw do
  devise_for :users

  resources :questions,
            controller: 'topics',
            only: [:index, :show, :new, :create] do
    resources :answers, controller: 'messages', only: [:create]
  end

  resources :messages, only: [] do
    resources :comments, only: [:create, :update]
  end

  resources :users, only: [:show, :edit, :update]

  root 'topics#index'
end
