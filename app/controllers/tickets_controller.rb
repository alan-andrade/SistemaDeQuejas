class TicketsController < ApplicationController

  before_filter :require_user   , :only =>  [:index, :new, :create, :show]
#  before_filter :require_admin,   :only =>  [:edit, :update, :assign_responsible]
  
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
    @ticket = Ticket.includes(:responsible, :student, {:changes=>[:responsible, :attachments]}, :attachments).find(params[:id])
    respond_to do |format|
      format.html     
      format.pdf  { send_data  Ticket.to_pdf(@ticket) }
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
    ## A student create a ticket
    #@ticket = if @current_user.admin? and params[:ticket].has_key? :student_id
    #            if params[:ticket][:student_id].empty?
    #              Ticket.new(params[:ticket])
    #            else
    #              student = User.find_by_uid params[:ticket][:student_id]
    #              student.tickets.build(params[:ticket])
    #            end
    #          else
    #            @current_user.tickets.build(params[:ticket])
    #          end
    ## Almost 10 lines cutted into 2. :D
    
    @ticket = Ticket.new(params[:ticket])
    @ticket.student = (User.find_by_uid(@ticket.student_id) or @current_user)
    @ticket.save ? 
      redirect_to(@ticket, :notice => 'Tu queja ha sido enviada') :
      render(:action => "new")

  end

  def update
    @ticket = Ticket.find(params[:id]); @ticket.current_user = @current_user
      if @ticket.update_attributes(params[:ticket])
        redirect_to(@ticket, :notice => 'Se ha actualizado la queja con exito.')
      else
        render :action => "edit"
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
