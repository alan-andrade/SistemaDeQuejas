class TicketsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, :only =>  [:edit, :update, :assign_responsible]
  #before_filter :require_student, :only =>  [:new]
  
  def index
    status  = params[:status]    
    ticket  = @current_user.student? ? @current_user.tickets : Ticket
    
    @tickets = case status
                when 'pending'  then  ticket.order('created_at DESC').pending
                when 'active'   then  ticket.order('created_at DESC').active
                when 'finished' then  ticket.order('created_at DESC').finished
              end    
    
    respond_to do |format|
      if request.xhr?
        format.js { @tickets.empty? ? render(:text=>'No hay Quejas') : render(:partial=>"tickets_table", :locals=>{:tickets=>@tickets.all}) }
      else
        format.html
      end
      
      format.pdf  do
        @tickets_to_report = Ticket.find(cookies['tickets_to_report'].split(' '))
        send_data Ticket.to_pdf(@tickets_to_report)
      end
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
    respond_to do |format|
      format.html     
      format.pdf  { send_data  Ticket.to_pdf(@ticket) }
    end
  end

  def new
    @ticket = @current_user.tickets.build
  end
  
  ## May be removed
  def edit
    @ticket = Ticket.find(params[:id])
  end

  def create    
    ## A student create a ticket
    @ticket = @current_user.tickets.build(params[:ticket]) unless params[:ticket].has_key? :student
    
    ## An administrator creates a ticket for the user.
    # Should receive the ID of the student.    
    student = User.find(params[:ticket][:student])

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to(@ticket, :notice => 'Tu queja ha sido enviada') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully updated.') }
      else
        format.html { render :action => "edit" }       
      end
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
    end
  end

  def assign_responsible
    @ticket = Ticket.find(params[:id])
    @ticket.responsible = @current_user
    
    if @ticket.save
      redirect_to ticket_path, :notice =>  "Has tomado la queja"
    else
      redirect_to ticket_path, :notice =>  "Ocurrio un Error. "
    end
  end
    
end
