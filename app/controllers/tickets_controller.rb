class TicketsController < ApplicationController

  before_filter :require_user
    
  def index
    status  = params[:status]    
    ticket  = @current_user.admin? ? Ticket : @current_user.tickets
    @tickets = case status
                when 'pending'  then  ticket.pending
                when 'active'   then  ticket.active
                when 'finished' then  ticket.finished
              end
    respond_to do |format|
      format.html do
        if request.xhr?
              @tickets.empty? ? 
              render(:text=>"No hay Quejas") :
              render(:partial=>'tickets_table', :locals=>{:tickets=>@tickets})
        end
      end
      
      format.pdf  do
          if cookies['tickets_to_report'].nil?
            redirect_to(tickets_path, :notice =>  "Debes seleccionar las quejas que quieres exportar") 
          else
            @tickets_to_report = Ticket.find(cookies['tickets_to_report'].split(","))
            render :pdf  => Ticket.first, :disposition => 'inline'
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
    
    if @ticket.update_attributes(params[:ticket])
      returnable = params[:ticket].has_key?(:responsible_id) ? @ticket.responsible.name : params[:ticket].values.first
    
      respond_to do |format|
        format.js   { render :text  =>  (returnable) and return }
        #format.html { redirect_to @ticket, :notice  =>  "Cambio Exitoso" }
      end
    else
      respond_to do |format|
        format.js   {render :text  => "ERROR"}
        format.html {redirect_to @ticket, :error=>"Error" }
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
  
  #GET
  def info        
    respond_to do |format|
      format.js do
        options={}
        Ticket::CORRESPONDING_TO.each{|option| options[option.to_sym]=option }
        render :json => options.to_json
      end
    end
  end
  
#  DEPRECATED
#  def assign_responsible
#    @ticket = Ticket.find(params[:id])
#    @managers = User.managers
#  end

  # PUT
  def close
    @ticket = Ticket.find(params[:id])
    @ticket.status  = Ticket::STATUS.last
    @ticket.current_user  = @current_user
    if @ticket.save
      redirect_to @ticket
    end
  end
    
end
