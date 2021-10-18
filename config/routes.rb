Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "tasks#index"
  resources :tasks, except: [:new] do
    resources :items do
      collection do
        put "mark_all_as_complete"
        put "mark_all_as_incomplete"
      end
    end
  end
end
