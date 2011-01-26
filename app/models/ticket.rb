require 'prawn'   #PDF Files Generation

class Ticket < ActiveRecord::Base
  # Arreglo de posibles estados de la queja
  STATUS              =   [:pending,  :active,  :finished].map(&:to_s).freeze
  CORRESPONDING_MAP   =   {:course  =>  [:professor, :content],
                           :admin   =>  [:employee],
                           :other   =>  [:other]}
                          .freeze
  CORRESPONDING_TO    =   CORRESPONDING_MAP.values.flatten.map(&:to_s).freeze
  # Relaciones con otras clases
  #
  #   belongs_to  :student
  #   belongs_to  :teacher
  #   belongs_to  :course
  #   belongs_to  :responsible
  # 
  #   Se descomentara mas adelante cuando se tenga mas idea sobre la implementacion.
  has_many  :changes, :dependent  =>  :destroy, :inverse_of=>:ticket
  
  ## Validators
  validates :student,           :presence   =>  true
  validates :corresponding_to,  :inclusion  =>  {:in => CORRESPONDING_TO}
  
  ## Scopes
  
  scope :pending, where(:status=>STATUS.first)
  scope :active,  where(:status=>STATUS[1])
  scope :finished,where(:status=>STATUS.last)
  
  ## Callbacks before saving record
  
  before_save {|t| t.status = STATUS[0] unless t.status? } # Could be fixed with the :deafult option in the migration.
  before_save :ticket_creation_change
  before_save :responsible_management
  
  #// TODO: get a good look for pdf rendering sheets.
  def self.to_pdf(*tickets)
    tickets.flatten!
    Prawn::Document.new do |pdf|
      if tickets.size == 1
        ticket  = tickets.first
        pdf.text ticket.created_at.to_formatted_s(:long)
        pdf.text ticket.description,  :align  =>  :center, :size => 20
        pdf.text "Evolucion", :size => 17
        for change in ticket.changes
          pdf.text change.created_at.to_formatted_s(:short)
        end
      else
        for ticket in tickets
          pdf.text ticket.created_at.to_formatted_s(:long)
          pdf.text ticket.description,  :align  =>  :center, :size => 20
          pdf.text "Evolucion", :size => 17
          for change in ticket.changes
            pdf.text change.created_at.to_formatted_s(:short)
          end
          pdf.text '-------------------------------'
        end        
      end     
    end.render
   
  end
  
  private
  def ticket_creation_change  
    if new_record?
      changes.build   :extern_comments  =>  "Levantamiento",
                      :intern_comments  =>  "Levantamiento",
                      :change_type      =>  "advance",
                      :responsible_id      =>  self          
    end
  end
  
  def responsible_management
    if responsible_changed?
      changes.build  :extern_comments  =>"La queja la ha tomado #{responsible}. Estamos trabajando en tu peticion",
                     :change_type      =>  "advance"                
      self.status = STATUS[1]
    end
  end
end
