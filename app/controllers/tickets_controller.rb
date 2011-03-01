class TicketsController < ApplicationController

  before_filter :require_user
    
  def index
    status  = params[:status]    
    ticket  = @current_user.student? ? @current_user.tickets : Ticket
    @tickets = case status
                when 'pending'  then  ticket.order('created_at DESC').pending
                when 'active'   then  ticket.order('created_at DESC').active
                when 'finished' then  ticket.order('created_at DESC').finished
              end            
    
    respond_to do |format|
      format.html do
        if request.xhr?
              @tickets.empty? ? 
              render(:text=>"No hay Quejas") :
              render(:partial=>"tickets_table", :locals=>{:tickets=>@tickets.all})
        end
      end
      
      format.pdf  do
          if cookies['tickets_to_report'].nil?
            redirect_to(tickets_path, :notice =>  "Debes seleccionar las quejas que quieres exportar") 
          else
            @tickets_to_report = Ticket.find(cookies['tickets_to_report'].split(' '))
            render :text  => Ticket.to_pdf(@tickets_to_report), :disposition => 'inline'
          end
      end
    end
  end

  def show
    @ticket = Ticket.complete.find(params[:id])
    respond_to do |format|
      format.html     
      format.pdf  { render :text  =>  Ticket.to_pdf(@ticket),  :disposition  =>  "inline"}
    end
  end

  def new
    @ticket = @current_user.admin? ? Ticket.new : @current_user.tickets.build
  end
  
  ## May be removed
  def edit
    @ticket = Ticket.find(params[:id])
  end

  def create    
    @ticket = Ticket.new(params[:ticket])
    @ticket.student = (User.find_by_uid(@ticket.student_id) or @current_user)
    @ticket.save ? 
      redirect_to(@ticket, :notice => 'Tu queja ha sido enviada') :
      render(:action => "new")
  end

  def update
    @ticket = Ticket.find(params[:id])
    @ticket.current_user = @current_user
    p params[:ticket]
    
    if @ticket.update_attributes(params[:ticket])
      if request.xhr?
        render(:text=>@ticket.responsible.name) and return
      end
      redirect_to(@ticket, :notice => 'Se ha actualizado la queja con exito.')
    else
      render(:action => "edit")
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
    @managers = User.managers
  end
    
end
