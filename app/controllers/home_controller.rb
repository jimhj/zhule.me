# coding: utf-8
class HomeController < ApplicationController
  layout 'home'
  before_filter :require_login

  def index
    @user = current_user
    params[:type] ||= 'followed'
    case params[:type]
    when 'followed'
      follower_ids = @user.user_follows.map(&:follower_id)
      @assistances = Assistance.where(:user_id.in => follower_ids).includes(:user)
    when 'assistances'
      @assistances = @user.assistances
    when 'helped'
      assistance_ids = @user.assistance_helpers.map(&:assistance_id)
      @assistances = Assistance.where(:_id.in => assistance_ids).includes(:user)
    end
  end
  
end