class HamsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def new
    @ham = Ham.new
  end

  def create
    @ham = current_user.hams.create(ham_params)
    if @ham.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
  end

  private

  def ham_params
    params.require(:ham).permit(:message)
  end

end
