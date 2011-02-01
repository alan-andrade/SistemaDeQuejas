class Change < ActiveRecord::Base
  
  CHANGE_TYPES  = [:advance, :waiting, :finished].map(&:to_s).freeze

  belongs_to :ticket, :inverse_of=>:changes
  
  validates :change_type, :inclusion=>{:in=>CHANGE_TYPES}  
  after_save :finished_ticket?
  
  ## TODO: Assure just a manager can make changes
  private 
  def finished_ticket?
    if change_type == CHANGE_TYPES.last
      ticket.update_attribute :status, Ticket::STATUS.last
    end
  end

end
