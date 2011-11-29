class Manage::PostsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @posts = current_user.posts.order('ID DESC')
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end
  
  def close
    post = Comment.find(params[:id]).post
    Comment.delete(params[:id])
    redirect_to manage_post_path(post)
  end
end
