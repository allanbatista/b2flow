Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  scope "/teams/:team_name" do
    resources :projects, except: [:destroy], param: :project_name
    resources :team_environments, only: [:index, :update, :destroy], param: :env_name, path: "environments"

    scope "/projects/:project_name" do
      resources :dags, except: [:destroy], param: :dag_name
      resources :project_environments, only: [:index, :update, :destroy], param: :env_name, path: "environments"

      scope "/dags/:dag_name" do
        resources :dag_environments, only: [:index, :update, :destroy], param: :env_name, path: "environments"

        post "/jobs/:job_name/build_callback", to: "jobs#build_callback"
      end
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
