SistemaDeQuejas::Application.routes.draw do
  root  :to=>"tickets#index"
  
  get "tickets/:status" => "tickets#index", 
    :constraints=>{:status=>/pending|active|finished/}, 
    :as=>'tickets_by_status'
    
  resources :tickets do    
    resources :changes
  end
  
  
  match "login"           =>  'access#new'
  match "logout"          =>  'access#destroy'
  match "authenticate"    =>  'access#create'
  match "users/:id"       =>  "users#show"
  
  get "tickets/report/:format"	=>	"tickets#index",
  	:as =>	"report_tickets"
  get "managers"  =>  "managers#index",
    :as =>  "managers"
  get "attachment/:id"  =>  "attachments#show",
    :as=>"show_attachment"
  get "ticket/info" =>  "tickets#info"
  post  "ticket_taker/:id"  =>  "managers#ticket_taker",
    :as => "ticket_taker"
  post  "/post/:post_id/comments" =>  "comments#create",
    :as => :post_comments
  post  "tickets/:id" =>  "tickets#close",
    :as   =>  :close_ticket
 
end
