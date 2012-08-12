# coding: utf-8
class UsersController < ApplicationController
  layout 'profile'
  before_filter :require_login, :except => :show

  def index
  end

  def show
    @user = User.where(:_id => params[:id]).first
    if params[:type].blank?
      @assistances = @user.assistances
    elsif params[:type] == 'helpeds'
      assistance_ids = @user.assistance_helpers.map(&:assistance_id)
      @assistances = Assistance.where(:_id.in => assistance_ids).includes(:user)
    end
    @assistances = @assistances.paginate(:page => params[:page], :per_page => 8)
    set_seo_meta("#{@user.login}的主页")
  end

  def follow
    follow = current_user.user_follows.create(:follower_id => params[:id])
    render :text => { :success => true }.to_json
  end

  
end