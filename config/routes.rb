Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  get 'nosotros', to: 'home#about_us', as: :about_us
  get 'la-ley', to: 'home#about_the_law', as: :about_the_law

  resources :public_bodies, path: 'administraciones', only: [:index, :show]

  resources :bidders, path: 'empresas', only: [:index, :show]

  resources :awards, path: 'contratos', only: [:index, :show]

  resources :articles, path: 'articulos', only: [:index, :show]

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
