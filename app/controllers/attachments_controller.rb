class AttachmentsController < ApplicationController
  def show
    @attachment = Attachment.find(params[:id])    
    redirect_to tickets_path and return unless Mime::LOOKUP.has_key? @attachment.content_type       
    send_data @attachment.content, :type =>  @attachment.extension, :disposition=>'inline', :filename =>  @attachment.file_name
  end
end
