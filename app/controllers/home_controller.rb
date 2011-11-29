class HomeController < ApplicationController
  def index
    @posts = Post.limit(10).order('ID DESC')
  end
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments if @post.comments
    @accounts = current_user.services if current_user
    @comment = Comment.new
  end
  
  def create
    @post = Post.find(params[:id])
    service = Service.find(params[:account])

    begin 
      user = LJAPI::User.new(service.login,service.password)
      @ljc = LJAPI::Request::AddComment.new(user, @post.post_id, @post.anum, params[:text].to_s).run
    rescue LJAPI::Request::LJException => e
      flash[:error] = t('ljapi.error.%s' % e.code)
      redirect_to show_post_path(@post)
    end
    @comment = Comment.new(:user => current_user.email, :text => params[:text], :url => @ljc)
    @post.comments << @comment
    redirect_to show_post_path(@post)
  end
end
