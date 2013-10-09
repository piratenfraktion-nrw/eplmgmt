# encoding: UTF-8

Eplmgmt::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :groups do
    resources :group_users, path: :users
    resources :pads
  end

  get '/p/:pad', to: 'pads#show', as: 'named_pad', only: [:show], format: false, id: /[\.[:digit:][:alpha:]%_-]+/
  get '/p/:group/:pad', to: 'pads#show', as: 'named_group_pad', only: [:show], format: false, group: /[\.[:digit:][:alpha:]%_-]+/, pad: /[\.[:digit:][:alpha:]%_-]+/
  get '/p', to: 'home#pads', as: 'named_pads'

  root :to => "home#index"
  resources :users

end
