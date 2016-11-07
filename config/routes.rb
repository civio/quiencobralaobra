Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  get 'guia-de-la-ley', to: 'pages#the_law', as: :the_law
  get 'glosario', to: 'pages#glossary', as: :glossary
  get 'metodologia', to: 'pages#methodology', as: :methodology

  get 'galeria', to: 'pages#gallery', as: :gallery

  resources :public_bodies, path: 'administraciones', only: [:index, :show]

  resources :bidders, path: 'grupos-constructores', only: [:index, :show]

  resources :awards, path: 'contratos', only: [:index, :show]

  resources :articles, path: 'articulos', only: [:index, :show]

  # Data json
  get 'data/grupos-constructores',      to: 'data#grupos_constructores', as: :grupos_constructores
  get 'data/administraciones',          to: 'data#administraciones', as: :data_administraciones

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
