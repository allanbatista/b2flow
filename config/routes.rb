Rails.application.routes.draw do
  resources :teams
  resources :users, only: [] do
    collection do
      get :me
    end
  end

  resources :authentications, only: [:create]
end
