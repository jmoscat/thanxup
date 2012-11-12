Thanxup::Application.routes.draw do
  devise_for :admins
  devise_for :owners
  resources :owner_approval, :only => [ :index ]
  resources :home, :only => [ :index ]
  resources :owners, :except => [ :index, :new, :create ] do
    scope :path => '/admins', :controller => :admins do
      put :approve_owner, :as => :admin_approve_owner
    end
  end
  root :to => 'home#index'
end
