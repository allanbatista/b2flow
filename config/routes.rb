Rails.application.routes.draw do
  scope "/teams/:team_name" do
    resources :projects, except: [:destroy], param: :project_name

    scope "/projects/:project_name" do
      resources :jobs, except: [:destroy], param: :job_name
    end
  end

  resources :teams, except: [:destroy], param: :team_name
  resources :users, only: [] do
    collection do
      get :me
    end
  end

  resources :authentications, only: [:create]
end
