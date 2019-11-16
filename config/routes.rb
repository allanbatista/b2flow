Rails.application.routes.draw do
  resources :projects, except: [:destroy]
  resources :teams, except: [:destroy]
  resources :users, only: [] do
    collection do
      get :me
    end
  end

  resources :authentications, only: [:create]
end
