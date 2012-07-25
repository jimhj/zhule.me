# coding: utf-8
class SettingsController < ApplicationController
  layout 'setting'
  before_filter :require_login

  def index
    if request.post?
      current_user.login = params[:login]
      current_user.address = params[:address]
      current_user.tag_list = params[:tag_list]
      current_user.tagline = params[:tagline]
      if current_user.save
        flash[:success] = '资料更新成功'
      else
        flash[:error] = current_user.errors.full_messages
      end
      redirect_to :back
    end
  end

  def password
    if request.post?
      if current_user.password == params[:current_password]
        current_user.password = params[:new_password]
        current_user.password_confirmation = params[:new_password_confirmation]
        if current_user.save
          flash[:success] = '密码修改成功'
        else
          flash[:error] = current_user.errors.full_messages
        end
      else
        flash[:error] = ['当前密码输入错误']
      end
      redirect_to :back
    end
  end

  def avatar
  end


end