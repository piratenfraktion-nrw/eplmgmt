# encoding: UTF-8

Eplmgmt::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :groups do
    resources :pads, only: [:index, :new, :create]
    resources :group_users, path: :users, only: [:index, :create]
  end

  resources :group_users, only: [:edit, :update, :destroy]
  resources :pads, only: [:edit, :update, :destroy]
  get '/p/:id', to: 'pads#show', only: [:show], format: false, id: /[\.[:digit:][:alpha:]%_-]+/
  get '/p/:group/:pad', to: 'pads#show', as: 'group_pad', only: [:show], format: false, group: /[\.[:digit:][:alpha:]%_-]+/, pad: /[\.[:digit:][:alpha:]%_-]+/
  get '/pads', to: 'pads#index', as: 'pads'

  root :to => "home#index"
  resources :users

end
