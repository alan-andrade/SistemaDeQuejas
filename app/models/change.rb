class Change < ActiveRecord::Base
  CHANGE_TYPES  = [:advance, :waiting, :finished].map(&:to_s).freeze

  belongs_to :ticket
  
  validates :change_type, :inclusion=>{:in=>CHANGE_TYPES}
  
  before_save :finished_ticket?
  
  private 
  def finished_ticket?
    if change_type == CHANGE_TYPES.last
      ticket.status = Ticket::STATUS.last
      ticket.save
    end
  end
end
