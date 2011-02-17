class Change < ActiveRecord::Base
  
  CHANGE_TYPES  = [:advance, :waiting, :manager, :finished].map(&:to_s).freeze  ## Watch out for i18n tables for rendering this values.

  belongs_to :ticket, :inverse_of=>:changes
  belongs_to :responsible,  :class_name =>  'User', :foreign_key  =>  'responsible_id'
  
  validates :change_type, :inclusion=>{:in=>CHANGE_TYPES}  
  after_save :finished_ticket?
  
  ## Evidence of change
  has_many  :attachments
  
  ## TODO: Assure just a manager can make changes
  private 
  def finished_ticket?
    if change_type == CHANGE_TYPES.last
      ticket.update_attribute :status, Ticket::STATUS.last
    end
  end

end
