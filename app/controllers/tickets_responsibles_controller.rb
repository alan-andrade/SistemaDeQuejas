class TicketsResponsiblesController < ApplicationController
  def edit
    @ticket = Ticket.find(params[:ticket_id])
  end
  
  def update
    @ticket = Ticket.find(params[:ticket_id])    
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }        
      end
    end
  end
end
