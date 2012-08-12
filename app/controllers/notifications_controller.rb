# coding: utf-8
class NotificationsController < ApplicationController
  before_filter :require_login
  layout 'home'

  def index
    @notifications = current_user.notifications.desc('created_at').paginate(:page => params[:page], :per_page => 15)
    current_user.read_notifications(@notifications)
    set_seo_meta("#{current_user.login} - 消息")
  end

  def destroy
  end

end