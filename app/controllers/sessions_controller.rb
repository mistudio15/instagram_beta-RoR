class SessionsController < ApplicationController
	skip_before_action :authenticate, only: [:new, :create]
	def new

	end

	def create
		user = User.authenticate(params[:email], params[:password])
		if user.nil?
			flash[:danger] = t('.danger')
			redirect_to '/signin'
		else
			flash[:success] = t('.success')
			session[:current_user_id] = user.id
			redirect_to user
		end
	end
	
	def destroy
		session[:current_user_id] = nil
		authenticate
	end
end