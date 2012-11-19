Thanxup::Application.routes.draw do
  devise_for :admins
  devise_for :owners
  resources :owner_approval, :only => [ :index ]
  scope :path => '/thanxup', :controller => :thanxup do
    get :home
    get :about
    get :contact
    get :unauthorized
  end
  resources :owners, :except => [ :index, :new, :create, :destroy ] do
    scope :path => '/admins', :controller => :admins do
      put :approve_owner, :as => :admin_approve_owner
    end
    resources :stores do
      resources :coupons
    end
  end

  root :to => 'thanxup#home'
end
