SistemaDeQuejas::Application.routes.draw do
  match 'tickets/:status' => "tickets#index", :constraints=>{:status=>/pending|active|finished/}, :via=>:get, :as=>'tickets_by_status'
  resources :tickets do
    get 'assign_responsible', :on  =>  :member, :as => 'responsible' # Temporarly routes. while we clarify technical doubts.
    resources :changes
  end
  
  root  :to=>"tickets#index"
  
  match "login"         =>  'access#new'
  match "logout"        =>  'access#destroy'
  match "authenticate"  =>  'access#create'
  match "users/:id"     =>  "users#show"
  
  get   "managers"                =>  "managers#index"  ,       :as =>  "managers"
  post  "ticket_taker/:id"        =>  "managers#ticket_taker",  :as => "ticket_taker"
  get   "attachment/:id"          =>  "attachments#show"  ,     :as=>"show_attachment"
  post  "/post/:post_id/comments" =>  "comments#create",        :as => :post_comments
  get   "ticket/info"             =>  "tickets#info"
  post  "tickets/:id"             =>  "tickets#close",          :as   =>  :close_ticket
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
