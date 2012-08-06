# coding: utf-8
class IndexController < ApplicationController
  layout 'public'
  before_filter :check_logged_in, :except => :sign_out
  before_filter :require_login, :only => :sign_out

  def index
    @assistances = Assistance.limit(6).desc('created_at').sample(3)
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
  end

  def sign_out
    clear_login_state
    redirect_to root_path
  end  

  private

  def check_logged_in
    redirect_to home_path and return if logged_in?
  end
    
end