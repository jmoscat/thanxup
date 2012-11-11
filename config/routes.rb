Thanxup::Application.routes.draw do
  devise_for :admins
  devise_for :owners
  resources :owner_approval, :only => [ :index ]
  resources :home, :only => [ :index ]
  resources :owner
  root :to => 'home#index'
end
