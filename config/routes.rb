Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'
  get 'sobre', to: 'pages#about', as: :about
  get 'ofertaspassadas', to: 'pages#finished_offers', as: :finished_offers
  get 'termosdecompras', to: 'pages#terms', as: :terms
  get 'cart', to: 'pages#cart', as: :cart
  delete 'clean_cart', to: 'offers#clean_cart', as: :clean_cart

  resources :offers, only: :show do
    member do
      get 'purchase', to: 'offers#new_purchase', as: :new_purchase
      post 'purchase', to: 'offers#create_purchase', as: :create_purchase
      post 'add_to_cart', to: 'offers#add_to_cart', as: :add_to_cart
      delete 'remove_from_cart', to: 'offers#remove_from_cart', as: :remove_from_cart
    end
  end

  resources :old_purchases, only: [:show, :update], path: 'deposit' do
    member do
      get '/success', to: 'old_purchases#success', as: :success
    end
  end

  get 'purchases', to: 'purchases#index', as: :purchases
  # checkout/update is used by Iugu to trigger payment update callbacks
  post "purchases/#{Rails.application.secrets.iugu_auth_code}/update", to: 'purchases#update', as: :purchase_update

  get 'checkout', to: 'checkouts#checkout', as: :checkout
  get 'checkout/success/:invoice_id', to: 'checkouts#success', as: :checkout_success
  post 'checkout/process_payment', to: 'checkouts#process_payment', as: :process_payment

  get '/index', format: :php, to: redirect('/')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
