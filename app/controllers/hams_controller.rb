class HamsController < ApplicationController
  def new
    @ham = Ham.new
  end

  def create
    @ham = Ham.create(ham_params)
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
