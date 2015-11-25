Rails.application.routes.draw do
  #match "students", :to => "students#index", :via => :get

  #match "students/:id1", :to => "students#info", :via => :get

  #match ':controller(/:id1(/:action(/:id2)))', :via => :get

  #match "/students", :to => "students#ric_post", :via => :post

  #match '/students(/:id1(/:action(/:id2)))' => 'students#ric_get', via: :get

  # ------------  Students ------------------------

  #put "students/:id1/coursesEnrolled/:id2" => "students#addcourse"
  #delete "students/:id1/coursesEnrolled/:id2" => "students#dropcourse"
  #put "students/:id1/coursesTaken/:id2" => "students#addcourse"
  #delete "students/:id1/coursesTaken/:id2" => "students#dropcourse"

  post "students/:id/:field" => "students#courselist"
  delete "students/:id/:field" => "students#courselist"
  put "students/:id/:field" => "students#overwritecourselist"

  put "students/:id1/lastName" => "students#changeinfo"
  put "students/:id1/firstName" => "students#changeinfo"
  put "students/:id1" => "students#changeinfo"

  post "students" => "students#create"
  delete "students/:id" => "students#delete"

  get "students" => "students#doget"
  get "students/:id1" => "students#doget"
  get "students/:id1/:field" => "students#doget"


  # -------------  Courses ------------------------

  put "courses/:id/students" => "courses#overwritestudentlist"
  post "courses/:id/students" => "courses#studentlist"
  delete "courses/:id/students" => "courses#studentlist"

  put "courses/:id1/room" => "courses#changeinfo"
  put "courses/:id1/title" => "courses#changeinfo"
  put "courses/:id1" => "courses#changeinfo"

  post "courses" => "courses#create"
  delete "courses/:id" => "courses#delete"

  get "courses" => "courses#doget"
  get "courses/:id1/:field" => "courses#doget"
  get "courses/:id1" => "courses#doget"

  match 'students(/:id1(/:action(/:id2)))', :to => 'students#doget', :via => [:post, :get]
  match 'courses(/:id1(/:action(/:id2)))', :to => 'courses#doget', :via => [:post, :get]

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
