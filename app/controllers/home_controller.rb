# coding: utf-8
class HomeController < ApplicationController
  layout 'home'
  before_filter :require_login

  def index
    @user = current_user
    params[:type] ||= 'followed'
    case params[:type]
    when 'followed', 'assistances'
      @assistances = @user.assistances.limit(100)
    end
  end
  
end