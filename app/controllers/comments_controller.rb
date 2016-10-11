class CommentsController < ApplicationController

	def create
		@micropost = Micropost.find(params[:micropost_id])
		@user = User.find(params[:user_id])
		@comment = @micropost.comments.create(user: @user, micropost: @micropost, content: comment_content[:content])
		redirect_to @user
	end
	
	def destroy
		@micropost = Micropost.find(params[:micropost_id])
		@comment = @micropost.comments.find(params[:id])
		@user = User.find(@comment.user.id)
		@comment.destroy
		redirect_to @user
  end
 
	private
    def comment_content
      params.require(:comment).permit(:content)
    end
end
