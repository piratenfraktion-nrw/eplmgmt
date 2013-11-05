# encoding: UTF-8

Eplmgmt::Application.routes.draw do

  devise_for :users, controllers: {registrations: 'registrations'}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :groups do
    resources :group_users, path: :users
    resources :pads
  end

  resources :pads

  get '/p/:pad',
      to: 'pads#show',
      as: 'named_pad',
      only: [:show],
      format: false,
      constraints: {
          pad: /[\.[:alnum:][:space:],%_-]+/
      }

  get '/p/:group/:pad',
      to: 'pads#show',
      as: 'named_group_pad',
      only: [:show],
      format: false,
      constraints: {
          group: /[\.[:alnum:][:space:],%_-]+/,
          pad: /[\.[:alnum:][:space:],%_-]+/
      }

  get '/p', to: 'home#pads', as: 'named_pads'

  root :to => "home#index"
  resources :users
end
