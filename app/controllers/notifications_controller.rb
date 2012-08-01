# coding: utf-8
class NotificationsController < ApplicationController
  before_filter :require_login
  layout 'home'

  def index
    @notifications = current_user.notifications.desc('created_at')
  end

  def destroy
  end

end