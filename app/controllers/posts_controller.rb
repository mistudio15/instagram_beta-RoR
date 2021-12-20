class PostsController < ApplicationController
	before_action :set_user, only: %i[ new create destroy show edit update likes]
	before_action :set_post, only: %i[ destroy show edit update likes]
	before_action :current_number_likes, only: %i[show]
	def new
		@post = @user.posts.build
		unless current_user.id == @user.id
      render plain: 'Access denied'
    end
	end

	def create 
		@post = @user.posts.build(post_params)
		if @post.save
      	redirect_to user_path(@user)
    else
      	render :new
    end
	end

	def edit
		unless current_user.id == @user.id
      render plain: 'Access denied'
    end
	end

	def update
		if @post.update(post_params)
      redirect_to user_post_path(@user, @post)
    else
      render :edit
    end
	end

	def show	
		@comment = @post.comments.build
		@comments = @post.comments.order :created_at
		@name_id = session[:current_user_id]
		@name = User.find(@name_id).name
	end

	def destroy
		# @post = @user.posts.find params[:id]
		@post.destroy
		redirect_to user_path(@user)
	end

	def likes
		@result = processing_delivered_like
		respond_to do |format| 
			format.json { render json: @result }
		end 
	end

	private
		def processing_delivered_like
			answers = {}

			current_number = Like.where(post_id: @post.id).count

			set_liked_before = Like.find_by(post_id: @post.id, user_id: current_user.id).present?
			if set_liked_before
				answers[:color] = 'black'
				answers[:number] = current_number - 1
				Like.destroy_by(post_id: @post.id, user_id: current_user.id)
			else
				answers[:color] = 'red'
				answers[:number] = current_number + 1
				p Like.new(post_id: @post.id, user_id: current_user.id).save
			end
			puts ">>>>>>>>>>>>>>>>> #{answers[:color]} >> #{answers[:number]}"
			answers
		end

		def current_number_likes
			@current_number = Like.where(post_id: @post.id).count
			set_liked_now = Like.find_by(post_id: @post.id, user_id: current_user.id).present?
			if set_liked_now
				@color = 'red'
			else
				@color = 'black'
			end
		end

		def set_post
      @post = @user.posts.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :photo)
    end
end
