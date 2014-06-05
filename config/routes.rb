Rails.application.routes.draw do
  devise_for :users

  resources :questions,
            controller: 'topics',
            only: [:index, :show, :new, :create] do
    resources :answers, controller: 'messages', only: [:create]
  end

  resources :messages, only: [] do
    resources :comments, only: [:create]
  end

  resources :users, only: [:show, :edit, :update]

  resources :tags, only: [:index]

  root 'topics#home'
end
