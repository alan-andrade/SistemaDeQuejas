class ManagersController < ApplicationController
  before_filter :require_admin
  
  def index
    @managers = User.managers
    respond_to do |format|
      format.js do 
        options = {}
        @managers.each{|man| options[man.id] = man.name }
        render :json  => options.to_json        
      end
    end
  end
  
  def ticket_taker
    @user = User.managers.find{|user| user.uid == params[:id]} # Ensuring only managers will be ticket_takers by using the scope managers.
    @user.ticket_taker  = true
    @user.save ?
      redirect_to(managers_path, :notice=>"Cambio Exitoso") : 
      redirect_to(managers_path, :notice=>"Error en el cambio")
  end
end
