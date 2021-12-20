class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def show
    @posts = @user.posts.order created_at: :desc
  end

  def new
    @user = User.new
  end

  def edit
    unless current_user.id == @user.id
      render plain: 'Access denied'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
      flash[:success] = t('.success')
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.id == current_user.id
      @user.destroy
      session[:current_user_id] = nil
      redirect_to users_path
    else
      @user.destroy
      redirect_to users_path
    end
    flash[:success] = t('.success')
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :name, :surname, :username, :description, :avatar)
    end
end
