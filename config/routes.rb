Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'books#index'

  # Example of regular route:
  get 'index' => 'books#index'
  get 'search' => 'books#search'
  get 'addBook' => 'books#addBook'
  get 'info' => 'books#info'
  get 'about_us' => 'books#about_us'
  get 'user' => 'api#userInfo'
  get 'api/register' => 'api#register', via: :all
  get 'api/login' => 'api#login', via: :all
  get 'api' => 'api#api', via: :all
  get 'api/check' => 'api#check', via: :all

  post 'index' => 'books#index'
  post 'search' => 'books#search'
  post 'addBook' => 'books#addBook'
  post 'info' => 'books#info'
  post 'about_us' => 'books#about_us'
  post 'api/register' => 'api#register', via: :all
  post 'api/login' => 'api#login', via: :all
  post 'api' => 'api#api', via: :all
  post 'api/check' => 'api#check', via: :all

  resource :books

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

  #match ':controller(/:action(/:id))(.:format)'
end
