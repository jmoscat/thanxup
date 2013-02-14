Thanxup::Application.routes.draw do
  devise_for :admins
  devise_for :owners
  resources :owner_approval, :only => [ :index ]
  scope :path => '/thanxup', :controller => :thanxup do
    get :home
    get :about
    get :contact
    get :unauthorized
    get :terms
    get :privacy
    get :subregion_options
  end
  resources :owners, :except => [ :index, :new, :create, :destroy ] do
    member do
      get :edit_payment
      put :update_payment
      delete :cancel_payment
      delete :remove_stripe_info
    end
    scope :path => '/admins', :controller => :admins do
      put :approve_owner, :as => :admin_approve_owner
    end
    resources :stores do
      resources :coupons
    end
    resources :campaigns, :except => [:show, :destroy] do
      member do
        delete :deactivate
      end
    end
  end
  root :to => 'thanxup#home'
end
