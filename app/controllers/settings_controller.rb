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
    if request.post?
      current_user.avatar = params[:avatar]
      if current_user.save
        current_avatar_path = File.join(Rails.root, 'public', current_user.avatar.url)
        image = MiniMagick::Image.open(current_avatar_path)
        redirect_to :back and return if image[:width] < 180 || image[:height] < 180 
        render :template => 'settings/crop_avatar'
      else
        flash[:error] = current_user.errors.full_messages
        redirect_to :back
      end
    end
  end

  def crop_avatar
    if request.post?
      begin
        current_avatar_path = File.join(Rails.root, 'public', current_user.avatar.url)
        x, y, w, h = params[:crop_position].split(',')
        image = MiniMagick::Image.open(current_avatar_path)
        image.crop("#{w}x#{h}+#{x}+#{y}!")
        image.coalesce(current_avatar_path, current_avatar_path) if image.mime_type == 'image/gif'
        current_user.avatar = image
        current_user.save
      rescue => e
        logger.error e
      end
      redirect_to setting_avatar_path
    end
  end


end