Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "sentences#index"

  resources :sentences, only: [:show, :index] do
    resources :entities, only: [:create]
  end
end
