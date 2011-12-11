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
    
    if Rails.cache.exist?(get_current_tag())
      @posts = read_current_cache()
    else
      begin
        @posts = LJAPI::Request::GetPosts.new(user).run
        # TODO : Optimize atomic transaction for deleting existing posts
        @posts.reject! { |k,v| account.posts.exists?(:post_id => v['itemid']) }
        write_cache(@posts)
      rescue LJAPI::Request::LJException => e
        flash[:error] = t('ljapi.error.%s' % e.code)
        redirect_to manage_blog_path
      end
    end
  end
  
  def add_post
    if Rails.cache.exist?(get_current_tag)
      @collection = read_current_cache()
      @p = @collection.fetch(params[:id].to_i)
      
      @post = Post.new(:subject => @p.subject, :text => @p.body, :anum => @p.anum, :time => @p.time, :post_id => @p.itemid)
      
      if @post.save
        current_user.posts << @post
        current_account.posts << @post
        @collection = @collection.reject { |k,v| k == @p.itemid }
        write_cache(@collection)
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
    if Rails.cache.exist?(get_current_tag())
      @collection = read_current_cache()
      @p = @collection.fetch(params[:id].to_i)
      
      begin
        @update = LJAPI::Request::EditPost.new(user, params[:id].to_i, { 'security' => 'public', 'event' => @p.body, 'subject' => @p.subject }).run
      rescue LJAPI::Request::LJException => e
        flash[:error] = t('ljapi.error.%s' % e.code)
        redirect_to manage_blog_path
      end
      if @update
        @post = Post.new(:subject => @p.subject, :text => @p.body, :anum => @update['anum'], :time => @p.time, :post_id => @update['itemid'])
        
        if @post.save
          current_user.posts << @post
          current_account.posts << @post
          @collection = @collection.reject { |k,v| k == @p.itemid }
          write_cache(@collection)
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
  
  private
  def current_account
    account = Service.find(session[:current_service]) if session[:current_service]
    account ||= current_user.service.first
    account
  end
  
  def get_current_tag()
    user = current_user.id.to_s
    service = current_account
    tag = "posts_#{user}_#{service.id}"
    tag
  end
  
  def write_cache(object, expires = 5.minutes)
    Rails.cache.write(get_current_tag,object, :expires_in => expires)
  end
  
  def read_current_cache()
    Rails.cache.read(get_current_tag)
  end
end
