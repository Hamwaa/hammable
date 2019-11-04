class HamsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def destroy
    @ham = Ham.find_by_id(params[:id])
    return render_not_found if @ham.blank?
    return render_not_found(:forbidden) if @ham.user != current_user
    @ham.destroy
    redirect_to root_path
  end

  def update
    @ham = Ham.find_by_id(params[:id])
    return render_not_found if @ham.blank?
    return render_not_found(:forbidden) if @ham.user != current_user
    @ham.update_attributes(ham_params)
    
    if @ham.valid?  
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

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
    @hams = Ham.all
  end

  def show
    @ham = Ham.find_by_id(params[:id])
    return render_not_found if @ham.blank?
  end

  def edit
    @ham = Ham.find_by_id(params[:id])
    return render_not_found if @ham.blank?
    return render_not_found(:forbidden) if @ham.user != current_user
  end


  private

  def ham_params
    params.require(:ham).permit(:message, :picture)
  end

  def render_not_found
    render plain: 'Not found :(', status: :not_found
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end
end
