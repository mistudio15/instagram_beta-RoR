class CommentsController < ApplicationController

	before_action :set_user, only: %i[create destroy]
	before_action :set_post, only: %i[create destroy]

	def create
		@username = User.find(current_user.id).username
		@comment = @post.comments.build(body: params[:comment][:body], username: @username)
		if @comment.save
      		redirect_to user_post_path(@user, @post)
    	else
    		@comments = @post.comments.order created_at: :desc
      		render 'posts/show'
    	end
  		# render plain: params
	end

	def destroy
		@comment = @post.comments.find(params[:id])
		@comment.destroy
		redirect_to user_post_path(@user, @post)
	end

	def set_post
      @post = @user.posts.find(params[:post_id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

	# def comment_params
 #      params.require(:comment).permit(:body)
 #    end
end
