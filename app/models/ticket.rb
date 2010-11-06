class Ticket < ActiveRecord::Base
  # Arreglo de posibles estados de la queja
  STATUS              =   [:pending,  :active,  :finished].map(&:to_s).freeze
  CORRESPONDING_TO    =   [:profesor, :course,  :content, :other].map(&:to_s).freeze
  # Relaciones con otras clases
  #
  #   belongs_to  :student
  #   belongs_to  :teacher
  #   belongs_to  :course
  #   belongs_to  :responsible
  # 
  #   Se descomentara mas adelante cuando se tenga mas idea sobre la implementacion.
  has_many  :changes, :dependent  =>  :destroy
  
  ## Validators
  validates :student_id,        :presence   =>  true
  validates :corresponding_to,  :inclusion  =>  {:in => CORRESPONDING_TO}
  
  ## Scopes
  
  scope :pending, where(:status=>STATUS.first)
  scope :active,  where(:status=>STATUS[1])
  scope :finished,where(:status=>STATUS.last)
  
  ## Callbacks before saving record
  
  before_save {|t| t.status = STATUS[0] if t.status.nil?} # Could be fixed with the :deafult option in the migration.
  before_save :responsible_changed?
  
  private
    
  def responsible_changed?
    if responsible_id_changed?             
      changes.create(
        :extern_comments=>"La queja la ha tomado #{responsible_id}. Estamos trabajando en tu peticion",
        :change_type  =>  "advance"
        )
      self.status = STATUS[1]
    end
  end
end
