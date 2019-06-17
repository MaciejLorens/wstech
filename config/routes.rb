Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  get 'search' => 'home#search'

  resources :metal_orders do
    resources :resources
    get :new_inquiry, on: :collection
    post :create_inquiry, on: :collection
    get :inquiry, on: :collection
    get :proposition, on: :collection
    get :not_confirmed, on: :collection
    get :ordered, on: :collection
    get :delivered_without_wz, on: :collection
    get :delivered_with_wz, on: :collection
    get :deleted, on: :collection
    get :download, on: :collection
    get :history, on: :member
  end

  resources :furniture_orders do
    resources :resources
    get :new_inquiry, on: :collection
    post :create_inquiry, on: :collection
    get :inquiry, on: :collection
    get :proposition, on: :collection
    get :not_confirmed, on: :collection
    get :ordered, on: :collection
    get :delivered_without_wz, on: :collection
    get :delivered_with_wz, on: :collection
    get :deleted, on: :collection
    get :download, on: :collection
    get :history, on: :member
  end

  resources :wzs, except: [:index] do
    get :download, on: :member
    get :index, on: :collection
    get :deleted, on: :collection
  end
end
