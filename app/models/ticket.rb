require 'prawn'   #PDF Files Generation

class Ticket < ActiveRecord::Base
  # Arreglo de posibles estados de la queja
  STATUS              =   [:pending,  :active,  :finished].map(&:to_s).freeze
  CORRESPONDING_MAP   =   {:curso           =>  [:profesor, :contenido, :calificacion],
                           :administrativo  =>  [:empleado, :papeleo],
                           :plataforma      =>  [:cuenta],
                           :otro            =>  [:otro]}
                          .freeze
  CORRESPONDING_TO    =   CORRESPONDING_MAP.values.flatten.map(&:to_s).freeze
  # Relaciones con otras clases
  #
  belongs_to  :student, :class_name =>  'User', :foreign_key  =>  'student_id'
  #   belongs_to  :teacher
  #   belongs_to  :course
  belongs_to  :responsible  , :class_name =>  'User', :foreign_key  =>  'responsible_id'
  # 
  #   Se descomentara mas adelante cuando se tenga mas idea sobre la implementacion.
  has_many  :changes, :dependent  =>  :destroy, :inverse_of=>:ticket
  
  ## Validators
  #validates :student,           :presence   =>  true :: not longer needed because of sessions.
  validates :corresponding_to,  :inclusion  =>  {:in => CORRESPONDING_TO}
  
  ## Scopes
  
  scope :pending, where(:status=>STATUS.first).includes(:student, :responsible)    
  scope :active,  where(:status=>STATUS[1])   .includes(:student, :responsible)
  scope :finished,where(:status=>STATUS.last) .includes(:student, :responsible)
  
  ## Callbacks before saving record
  
  before_save {|t| t.status = STATUS[0] unless t.status? } # Could be fixed with the :deafult option in the migration.
  before_save :ticket_creation_change
  before_save :responsible_management
  before_create :generate_id
  
  after_save #####  Do a trigger for Itzel to take your ticket inmediately.
  
  
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
      changes.build   :extern_comments  =>  "Tu queja ha sido enviada",
                      :intern_comments  =>  "Levantamiento",
                      :change_type      =>  "advance",
                      :responsible_id   =>  student.id
    end
  end
  
  def responsible_management
    if responsible_id_changed?
      changes.build  :extern_comments  =>"Tu queja esta en proceso",
                     :change_type      =>  "advance",
                     :responsible_id   =>     responsible.id
      self.status = STATUS[1]
    end
  end
  
  # A ticket has an id depending on which time was created.
  def generate_id
    day = if Date.today.day.to_s.length == 1
            "0" + Date.today.day.to_s
          else
            Date.today.day.to_s
          end
   month  = if Date.today.month.to_s.length ==  1
              "0" + Date.today.month.to_s
            else
              Date.today.month.to_s
            end
    year  = Date.today.year.to_s
    mili  = Time.now.to_f.to_s[11..13]
    self.id  = year+month+day+mili
  end
end
