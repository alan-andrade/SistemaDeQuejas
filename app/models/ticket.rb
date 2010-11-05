class Ticket < ActiveRecord::Base
  # Arreglo de posibles estados de la queja
  STATUS =  [:pending, :active, :finished].freeze
  
  # Relaciones con otras clases
  #
  #   belongs_to  :student
  #   belongs_to  :teacher
  #   belongs_to  :course
  #   belongs_to  :responsible
  # 
  #   Se descomentara mas adelante cuando se tenga mas idea sobre la implementacion.
  
  
  validates :student_id,  :presence  =>  true
  validates :status,      :presence =>  true
  
  before_save {|t| t.status = STATUS[0] }
end
