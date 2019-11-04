class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @ham = Ham.find_by_id(params[:ham_id])
    return render_not_found if @ham.blank?

    @ham.comments.create(comment_params.merge(user: current_user))
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
