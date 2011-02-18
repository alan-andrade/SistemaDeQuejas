class Attachment < ActiveRecord::Base
  validates_inclusion_of  :content_type, :in  =>  Mime::LOOKUP.keys, :message=> "Formato de Archivo Invalido"
  validates_length_of  :content,  :maximum  => 1.megabyte
  
  def extension
    content_type.match(/\/(\w*)/)[1]
  end
end
