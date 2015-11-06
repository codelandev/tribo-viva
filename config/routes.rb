Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'
  get 'sobre',            to: 'pages#about',           as: :about
  get 'carrinho',         to: 'pages#cart',            as: :cart
  get 'ofertas-passadas', to: 'pages#finished_offers', as: :finished_offers
  get 'termos-de-compra', to: 'pages#terms',           as: :terms
  get 'entregas',         to: 'pages#delivery',        as: :delivery
  delete 'clean_cart',    to: 'offers#clean_cart',     as: :clean_cart

  resources :offers, only: :show, path: 'ofertas' do
    member do
      post 'adicionar-ao-carrinho', to: 'offers#add_to_cart',      as: :add_to_cart
      delete 'remover-do-carrinho', to: 'offers#remove_from_cart', as: :remove_from_cart
    end
  end

  resources :producers, only: [:show, :index], path: 'produtores'

  get 'minhas-compras', to: 'purchases#index', as: :purchases
  # checkout/update is used by Iugu to trigger payment update callbacks
  post "purchases/#{Rails.application.secrets.iugu_auth_code}/update", to: 'purchases#update', as: :purchase_update

  get 'checkout',                      to: 'checkouts#checkout',        as: :checkout
  get 'checkout/success/:invoice_id',  to: 'checkouts#success',         as: :checkout_success
  get 'checkout/transfer/:invoice_id', to: 'checkouts#transfer',        as: :checkout_transfer
  post 'checkout/process_payment',     to: 'checkouts#process_payment', as: :process_payment
  patch 'checkout/:invoice_id',        to: 'checkouts#update',          as: :checkout_update

  get '/index', format: :php, to: redirect('/')
end
