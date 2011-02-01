class TicketsController < ApplicationController
  before_filter :require_user
  
  def index
    status  = params[:status]    
    @tickets = case status
                when 'pending'  then  Ticket.order('created_at DESC').pending
                when 'active'   then  Ticket.order('created_at DESC').active
                when 'finished' then  Ticket.order('created_at DESC').finished
              end    

    respond_to do |format|
      if request.xhr?
        format.js { @tickets.empty? ? render(:text=>'No hay Quejas') : render(:partial=>"tickets_table", :locals=>{:tickets=>@tickets.all}) }
      else
        format.html # index.html.erb
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
    @ticket = Ticket.new
    params.each_pair{|key, attr| @ticket.send("#{key}=", attr) if @ticket.respond_to?(key) }
    respond_to do |format|
      format.html      
    end
  end
  
  def edit
    @ticket = Ticket.find(params[:id])
  end

  def create
    @ticket = Ticket.new(params[:ticket])    

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
  end
    
end
