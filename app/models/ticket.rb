class Ticket < ActiveRecord::Base
  # Arreglo de posibles estados de la queja
  STATUS              =   [:pending,  :active,  :finished].freeze
  CORRESPONDING_TO    =   [:profesor, :course,  :content, :other].freeze
  # Relaciones con otras clases
  #
  #   belongs_to  :student
  #   belongs_to  :teacher
  #   belongs_to  :course
  #   belongs_to  :responsible
  # 
  #   Se descomentara mas adelante cuando se tenga mas idea sobre la implementacion.
  has_many  :changes, :dependent  =>  :destroy
  
  validates :student_id,  :presence  =>  true  
  
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
