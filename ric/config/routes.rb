Rails.application.routes.draw do

  get "students/:id1/:field" => "students#changeinfo"
  get "students/:id1" => "students#changeinfo"  
  get "students" => "students#changeinfo"  

  post "students/:id/:field" => "students#courselist"
  put "students/:id/:field" => "students#overwritecourselist"

  post "students" => "students#create"
  delete "students/:id" => "students#delete"

  # -------------  Courses ------------------------

  get "courses/:id1/:field" => "courses#changeinfo"
  get "courses/:id1" => "courses#changeinfo"
  get "courses" => "courses#changeinfo"

  post "courses/:id/:field" => "courses#studentlist"
  put "courses/:id/:field" => "courses#overwritestudentlist"

  match ':controller(/:id1(/:action(/:id2)))', :via => [:get, :post, :put]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
