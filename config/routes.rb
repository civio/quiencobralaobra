Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'


  get 'la-ley', to: 'pages#the_law',                                  as: :the_law_0, :defaults => { :id => 0 }
  get 'la-ley/a-quien-aplica', to: 'pages#the_law',                   as: :the_law_1, :defaults => { :id => 1 }
  get 'la-ley/tipos-de-contrato-por-el-objeto', to: 'pages#the_law',  as: :the_law_2, :defaults => { :id => 2 }
  get 'la-ley/tipos-de-contrato-por-el-proceso', to: 'pages#the_law', as: :the_law_3, :defaults => { :id => 3 }
  get 'la-ley/cuando-se-permite-el-uso-del-procedimiento-negociado', to: 'pages#the_law', as: :the_law_4, :defaults => { :id => 4 }
  get 'la-ley/obligaciones-de-publicidad', to: 'pages#the_law',       as: :the_law_5, :defaults => { :id => 5 }
  get 'la-ley/prohibiciones-para-contratar-con-las-aapp', to: 'pages#the_law', as: :the_law_6, :defaults => { :id => 6 }
  get 'la-ley/los-tiempos', to: 'pages#the_law',                      as: :the_law_7, :defaults => { :id => 7 }
  get 'la-ley/clausulas-de-resolucion', to: 'pages#the_law',          as: :the_law_8, :defaults => { :id => 8 }
  
  get 'glosario', to: 'pages#glossary', as: :glossary
  get 'metodologia', to: 'pages#methodology', as: :methodology

  resources :public_bodies, path: 'administraciones', only: [:index, :show]

  resources :bidders, path: 'empresas', only: [:index, :show]

  resources :awards, path: 'contratos', only: [:index, :show]

  resources :articles, path: 'articulos', only: [:index, :show]

  # Data json
  get 'data/empresas', to: 'data#empresas', as: :data_empresas
  get 'data/administraciones', to: 'data#administraciones', as: :data_administraciones

  # Data analysis
  get '/admin/data_analysis', to: 'data_analysis#index', as: :data_analysis_index
  get '/admin/data_analysis/show_attributes', to: 'data_analysis#show_attributes', as: :data_analysis_show_attributes
  get '/admin/data_analysis/cpv_not_available', to: 'data_analysis#cpv_not_available', as: :data_analysis_cpv_not_available

  # Admin interface
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

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
