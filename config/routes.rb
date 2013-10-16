# encoding: UTF-8

Eplmgmt::Application.routes.draw do

  devise_for :users, controllers: {registrations: 'registrations'}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :groups do
    resources :group_users, path: :users
    resources :pads
  end

  get '/p/:pad', to: 'pads#show', as: 'named_pad', only: [:show], format: false, pad: /\A[\.[:alnum:][:space:],%_-]+\z/
  get '/p/:group/:pad', to: 'pads#show', as: 'named_group_pad', only: [:show], format: false, group: /\A[\.[:alnum:][:space:],%_-]+\z/, pad: /\A[\.[:alnum:][:space:],%_-]+\z/
  get '/p', to: 'home#pads', as: 'named_pads'

  root :to => "home#index"
  resources :users
end
