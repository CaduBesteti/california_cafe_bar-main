Rails.application.routes.draw do
  get 'barcodes/scan'
  get 'barcodes/search'
  get 'dashboard/Index'
  get 'home/index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :stocks do
    member do
      get 'amount'
    end
  end
  resources :clients

  resources :sales do
    member do
      get :download_recipe
    end
  end

  # Ajuste a rota para 'dashboard' aqui, incluindo a ação de exportar para Excel
  resources :dashboard, only: [:index] do
    collection do
      get :export_to_excel, format: :xlsx
      get :export_week_sales, as: 'export_week_sales'
      get :export_csv, as: :dashboard_export_csv
    end
  end
  
  resources :users, only: %i[new create]
  resources :sessions, only: %i[new index create destroy]

  delete '/logout', to: 'sessions#destroy', as: :logout

  get '/dashboard/sales', to: 'dashboard#sales', as: :dashboard_sales
  get '/dashboard/compare-months', to: 'dashboard#compare_months', as: :dashboard_compare_months
  get '/dashboard/stock', to: 'dashboard#stock', as: :dashboard_stock
  get '/dashboard/export', to: 'dashboard#export', as: :dashboard_export_to_excel
  get 'dashboard/export_to_excel', to: 'dashboard#export_to_excel', as: :dashboard_export
  

  get 'details_by_month/:month', to: 'dashboard#details_by_month', as: 'details_by_month'

  

  get 'login', to: 'sessions#index'
  post 'login', to: 'sessions#create'

  get 'login/new', to: 'sessions#new'
  post 'sessions/new', to: 'sessions#create'

  # Route for the scan page (input field to scan barcode)
  get 'barcodes/scan', to: 'barcodes#scan'
  

  resources :barcodes do
    post 'finish_sale', on: :collection
    post 'cancel_sale', on: :collection
  end

  # Route to handle the barcode search
  post 'barcodes/search', to: 'barcodes#search'

  root 'home#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
