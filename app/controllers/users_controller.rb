class UsersController < ApplicationController

  def show 
    @user = User.find_by_uid(params[:id])
    respond_to do |format|
      format.js { render :json  =>  @user.to_json }
    end
  end

end
