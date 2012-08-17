# coding: utf-8
class IndexController < ApplicationController
  layout 'public'
  before_filter :check_logged_in, :except => [:sign_out, :square]
  before_filter :require_login, :only => [:sign_out]

  def index
    @assistances = Assistance.includes(:user).desc('created_at').limit(6).sample(3)
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user.present?
        user.update_attribute(:last_logged_at, Time.now)
        self.current_user = user
      else
        flash[:error] = '账号或者密码不正确'
      end
      redirect_to :back
    end
    set_seo_meta
  end

  def sign_up
    if request.post?
      user = User.new(params[:user])
      if user.save
        user.update_attribute(:last_logged_at, Time.now)
        self.current_user = user
      else
        flash[:error] = user.errors.full_messages
      end
      redirect_to :back
    end
    set_seo_meta
  end

  def sign_out
    clear_login_state
    redirect_to root_path
  end

  def square
  end

  private

  def check_logged_in
    redirect_to home_path and return if logged_in?
  end
    
end