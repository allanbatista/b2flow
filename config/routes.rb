Rails.application.routes.draw do
  default_url_options :host => AppConfig.B2FLOW__HOSTNAME rescue puts "not hostname defined"

  scope "/teams/:team_name" do
    resources :projects, except: [:destroy], param: :project_name

    scope "/projects/:project_name" do
      resources :jobs, except: [:destroy], param: :job_name

      scope "/jobs/:job_name" do
        resources :versions, except: [:destroy]
        resources :settings, except: [:destroy]
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
