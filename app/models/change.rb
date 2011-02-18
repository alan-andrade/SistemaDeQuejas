class Change < ActiveRecord::Base
  
  CHANGE_TYPES  = [:advance, :waiting, :manager, :finished].map(&:to_s).freeze  ## Watch out for i18n tables for rendering this values.
  
  belongs_to :ticket, :inverse_of=>:changes
  belongs_to :responsible,  :class_name =>  'User', :foreign_key  =>  'responsible_id'
  
  validates :change_type, :inclusion=>{:in=>CHANGE_TYPES}
  validate  :student_close_ticket  
  after_save :finished_ticket?
  
  ## Evidence of change
  has_many  :attachments
  
  ## TODO: Assure just a manager can make changes
  private 
  
  def finished_ticket?
    ticket.update_attribute(:status, Ticket::STATUS.last) if change_type == CHANGE_TYPES.last
  end
  def student_close_ticket
    errors.add(:base, "Solo un estudiante puede cerrar la queja") if (responsible.admin? and change_type = CHANGE_TYPES.last)
  end

end
