class AccessController < ApplicationController
  before_filter :require_no_user,   :only  =>  [:new, :create]
  before_filter :require_user,      :only  =>  [:destroy]
  
  def new; end  #login
  
  def create  #Authenticate User.
    @user = User.authenticate(params[:user],params[:password]);
    
    if @user
      session[:user]  = @user.uid
      redirect_to tickets_path
    else  
      flash[:now] = "No coinciden tus datos. Intentalo nuevamente"
      render :new
    end
  end
  
  def destroy
    session[:user]  = nil
    redirect_to login_path, :notice =>  'Estamos a tus ordenes'
  end
end
