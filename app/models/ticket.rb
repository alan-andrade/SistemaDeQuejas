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
  
  ## Atributo para controlar el usuario actual.
  cattr_accessor  :current_user ## DO NOT REMOVE OR CHANGE. Used in :responsible_management
  
  has_many  :attachments
  accepts_nested_attributes_for :attachments
  
  # Relaciones con otras clases
  #
  belongs_to  :student  ,     :class_name =>  'User', :foreign_key  =>  'student_id'
  #   belongs_to  :teacher
  #   belongs_to  :course
  belongs_to  :responsible  , :class_name =>  'User', :foreign_key  =>  'responsible_id'
  # 
  #   Se descomentara mas adelante cuando se tenga mas idea sobre la implementacion.
  has_many  :changes, :dependent  =>  :destroy, :inverse_of=>:ticket
  
  ## Validators
  #validates :student,           :presence   =>  true :: not longer needed because of sessions.
  validates :corresponding_to,  :inclusion  =>  {:in => CORRESPONDING_TO}
  validates :student_id,  :presence =>  true
  
  ## Scopes
  scope :pending, where(:status=>STATUS.first).includes(:student, :responsible)    ## Would be great to keep DRY here. how?
  scope :active,  where(:status=>STATUS[1])   .includes(:student, :responsible)
  scope :finished,where(:status=>STATUS.last) .includes(:student, :responsible)
  
  ## Callbacks before saving record
  
  before_create {|t| t.status = STATUS[0] unless t.status? } # Could be fixed with the :deafult option in the migration.
  before_create :designed_responsible_takeover #####  create a trigger for Itzel to take the ticket inmediately.
  before_save :ticket_creation_change
  before_save :responsible_management
  #before_create :generate_id
  
  
  
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
      changes.build   :extern_comments  =>  "Tu queja ha sido enviada. Estamos resolviendo tu peticion.",
                      :intern_comments  =>  "Se levanto la queja",
                      :change_type      =>  Change::CHANGE_TYPES[0],  #Advance Change.
                      :responsible_id   =>  student.id
    end
  end
  
  def responsible_management
    if responsible_id_changed?
      changes.build  :extern_comments  => "Ha cambiado el responsable que lleva la resolucion de tu queja.",
                     :intern_comments  => "Se asigno a #{User.find(responsible_id).name} como responsable",
                     :change_type      =>  Change::CHANGE_TYPES[2], #Manager Change
                     :responsible_id   =>  current_user.nil? ? responsible_id : current_user.id
      self.status = STATUS[1]
    end
  end
  
  def designed_responsible_takeover
    user  = User.ticket_taker.first
    self.responsible  = user
  end
  
end
