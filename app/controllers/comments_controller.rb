class CommentsController < ApplicationController
  before_filter :require_user
  
  def create
    post      = Post.find(params[:post_id])
    @comment  = post.comments.build(params[:comment])
    @comment.responsible  = @current_user
    if @comment.save
      respond_to  do |format|
        format.js{@comment}
        format.html{redirect_to ticket_path(@comment.ticket), :notice =>  "Comentado" }
      end
    end
  end

end
