# coding: utf-8
class AuthController < ApplicationController

  def weibo_login
    auth = request.env["omniauth.auth"]
    @auth_hash = {
      :uid          =>    auth.uid,
      :name         =>    auth.info.name,
      :avatar_url   =>    auth.info.avatar_url,
      :weibo_token  =>    auth.credentials.token
    }
    user = User.find_by_weibo_uid(@auth_hash[:uid])
    if user.present?
      self.current_user = user
      redirect_to home_path
    else
      render :layout => 'public'
    end
  end

  def new_user
    @auth_hash = eval(params[:auth] || '')
    email = params[:email]
    if User.where(:email => email).exists?
      flash[:error] = 'Email 已经被注册过了'
      render :template => 'auth/weibo_login', :layout => 'public' 
    else
      user = User.create_by_email_and_auth(email, @auth_hash)
      if user
        user.update_attribute(:last_logged_at, Time.now)
        self.current_user = user
        redirect_to home_path
      else
        flash[:error] = '注册出错了...'
        render :template => 'auth/weibo_login', :layout => 'public'        
      end
    end
  end

end