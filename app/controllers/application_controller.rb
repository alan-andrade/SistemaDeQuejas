class ApplicationController < ActionController::Base
  protect_from_forgery  
  
  def require_user
    unless current_user
      redirect_to login_path, :notice=>'Debes iniciar sesion para ingresar a la pagina'
    end
  end
  
  def require_no_user
    if current_user
      redirect_to logout_path, :notice  =>  'Debes terminar sesion'
    end
  end
  
  def current_user
    session[:user].nil? ? false : @current_user = User.where("uid = '#{session[:user]}'").first
  end
  
  def require_admin
    require_user unless @current_user
    unless @current_user.admin?
      redirect_to ticket_path,  :notice =>  "NO puede ejecutar esta operacion porque no tienes permiso."
    end
  end
  
  def require_student
    require_user unless @current_user
    unless @current_user.student?
      redirect_to tickets_path,  :notice =>  "NO puede ejecutar esta operacion porque no tienes permiso."
    end
  end
end
