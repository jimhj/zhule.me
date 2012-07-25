# coding: utf-8
class UsersController < ApplicationController
  layout 'profile'
  before_filter :require_login

  def index
  end

  def show
    @user = User.where(:_id => params[:id]).first
  end

  def follow
    follow = current_user.user_follows.build(:follower_id => params[:id])
    render :text => { :success => follow.save }.to_json
  end

  
end