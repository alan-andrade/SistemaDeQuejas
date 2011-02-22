class Change < Post
  
  CHANGE_TYPES  = [:advance, :waiting, :manager, :finished].map(&:to_s).freeze  ## Watch out for i18n tables for rendering this values.
  CHANGE_TYPES_FOR_VIEWS  = CHANGE_TYPES[0..1]  ## These are changes that will be rendered in #changes#new
  
  belongs_to :ticket      , :inverse_of=>:changes
  belongs_to :responsible ,  :class_name =>  'User', :foreign_key  =>  'responsible_id'
  has_many  :comments
   
  validates :change_type, :inclusion=>{:in=>CHANGE_TYPES}
  validate  :student_close_ticket 
  after_save :finished_ticket?  
  
  ## TODO: Assure just a manager can make changes
  private 
  
  def finished_ticket?
    ticket.update_attribute(:status, Ticket::STATUS.last) if change_type == CHANGE_TYPES.last
  end
  def student_close_ticket
    errors.add(:base, "Solo un estudiante puede cerrar la queja") if (responsible.admin? and change_type == CHANGE_TYPES.last)
  end

end
