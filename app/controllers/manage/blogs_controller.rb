class Manage::BlogsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  before_filter :authenticate_user!
  def index
    @accounts = current_user.services
  end
  
  def not_found(exception)
    flash[:error] = t('record_not_found')
    redirect_to(:back)
  end
  
  def import
    account = Service.find(params[:account])
    user = LJAPI::User.new(account.login, account.password)
    session[:current_service] = params[:account]
    if Rails.cache.exist?('posts')
      @posts = Rails.cache.read('posts')
    else
      begin
        @posts = LJAPI::Request::GetPosts.new(user).run
        Rails.cache.write('posts', @posts, :expires_in => 5.minutes)
      rescue LJAPI::Request::LJException => e
        flash[:error] = t('ljapi.error.%s' % e.code)
        redirect_to manage_blog_path
      end
    end
  end
  
  def add_post
    if Rails.cache.exist?('posts')
      @collection = Rails.cache.read('posts')
      @segment = @collection.fetch(params[:id].to_i)
      
      @post = Post.new
      @post.subject = @segment.subject
      @post.text = @segment.body
      @post.anum = @segment.anum
      @post.time = @segment.time
      @post.post_id = @segment.itemid
      
      if @post.save
        current_user.posts << @post
        respond_to do |format|
          format.js { render }
        end
      end
    else
      flash[:notice] = t('manage.blogs.cache_expired')
      render :js => "window.location = '/manage/blogs'"
    end
  end
  
  def unlock_add_post
    account = Service.find(session[:current_service])
    user = LJAPI::User.new(account.login,account.password)
    if Rails.cache.exist?('posts')
      @collection = Rails.cache.read('posts')
      @segment = @collection.fetch(params[:id].to_i)
      
      begin
        @update = LJAPI::Request::EditPost.new(user, params[:id].to_i, { 'security' => 'public', 'event' => @segment.body, 'subject' => @segment.subject }).run
      rescue LJAPI::Request::LJException => e
        flash[:error] = t('ljapi.error.%s' % e.code)
        redirect_to manage_blog_path
      end
      if @update
        @post = Post.new
        @post.subject = @segment.subject
        @post.text = @segment.body
        @post.time = @segment.time
        @post.post_id = @update.itemid
        
        if @post.save
          current_user.posts << @post
          respond_to do |format|
            format.js { render }
          end
        end
      end
    else 
      flash[:notice] = t('manage.blogs.cache_expired')
      render :js => "window.location = '/manage/blogs'"
    end
  end
  
  def show
    
  end
end
