Rails.application.routes.draw do
  root to: 'home#index'

  resources :crawl, only: [:new] do
    collection do
      post :scrap
      get :profile
    end
  end
end
