class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user = User.find(session[:user])
  end
  
  def require_user
    unless current_user
      redirect_to login_path, :notice=>'Debes iniciar sesion para ingresar a la pagina'
    end
  end
  
  def require_no_user
    if current_user
      redirect_to tickets_path, :notice=>'Debes de terminar sesion para ver esta pagina'
    end
  end
end
