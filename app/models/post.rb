class Post < ActiveRecord::Base


  ## Evidence of change
  has_many  :attachments, :dependent  =>  :destroy
  def file=(file)
    attachment              = attachments.build(:content  => file.read)
    attachment.file_name    = file.original_filename
    attachment.content_type = file.content_type
  end
end
