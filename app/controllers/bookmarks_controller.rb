class BookmarksController < ApplicationController
    def create
        @post = Post.find(params[:post_id])
        current_user.bookmark(@post)
        # redirect_to posts_path
      end
    
      def destroy
        @post = current_user.bookmarks.find(params[:id]).post
        current_user.unbookmark(@post)
        # redirect_to posts_path
      end
end
