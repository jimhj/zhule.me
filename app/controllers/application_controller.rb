# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def logged_in?
    current_user.present?
  end
  
  def require_login
    unless logged_in?
      clear_login_state
      flash[:error] = '请登录后访问'
      redirect_to root_path
      return
    end
  end

  def current_user    
    @current_user ||= begin
      login_from_session || login_from_cookie
    end

    # @current_user ||= begin
    #   User.current = (login_from_session || login_from_cookie)  
    # end
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || nil
  end

  def login_from_session
    self.current_user = User.where(:_id => session[:user_id]).first if session[:user_id]
  end

  def login_from_cookie
    nil
  end

  def clear_login_state
    current_user = nil
    session[:user_id] = nil
    session.clear
  end

  def set_seo_meta(title = nil, meta_keywords = nil, meta_description = nil)
    default_keywords = "助乐，助乐网，帮助别人，快乐自己，基于互相帮助的小微社区，致力于解决生活中的小麻烦"
    default_description = %Q(助乐 是一个基于互相帮助的小微社区，你可以在这里尝试把你的愿望，困难或者想法说出来让大家一起帮你，或者你也可以使用你的能力和爱心， 去帮助需要帮助的人，同时获得快乐。)
    @page_title = "#{title}" if title.present?      
    @keywords = meta_keywords || default_keywords
    @description = meta_description || default_description
  end  


end
