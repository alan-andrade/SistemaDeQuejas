class ChangesController < ApplicationController
  def new
    @ticket =   Ticket.find(params[:ticket_id])
    @change =   @ticket.changes.build
  end
  
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @change = @ticket.changes.build(params[:change])
    respond_to do |format|
      if @change.save
        flash[:notice]  = "Cambio guardado exitosamente"
        format.html{redirect_to ticket_path(@ticket)}        
      else
        flash[:notice]  = "Hubo un error"
        format.html{render  :action=>:new}
      end
    end
  end
end
