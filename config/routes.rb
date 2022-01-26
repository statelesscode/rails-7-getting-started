Rails.application.routes.draw do
  get 'welcome/index'
  root "welcome#index"

  resources :articles do
    resources :comments
  end

  resources :posts
end
