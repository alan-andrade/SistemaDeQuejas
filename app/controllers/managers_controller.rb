class ManagersController < ApplicationController
  before_filter :require_admin
  
  def index
    @managers = User.managers
  end
  
  def ticket_taker
    @user = User.managers.find{|user| user.uid == params[:id].to_i} # Ensuring only managers will be ticket_takers by using the scope managers.
    @user.ticket_taker  = true
    @user.save ?
      redirect_to(managers_path, :notice=>"Cambio Exitoso") : 
      redirect_to(managers_path, :notice=>"Error en el cambio")
  end
end
