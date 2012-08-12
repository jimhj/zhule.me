# coding: utf-8
class DialogsController < ApplicationController
  layout 'home'
  before_filter :require_login

  def index
    @dialogs = Dialog.where(:to_user_id => current_user.id).includes(:from_user)
    set_seo_meta("#{current_user.login} - 私信")
  end

  def show
    @dialog = Dialog.where(:_id => params[:id]).first
    unless @dialog.to_user_id == current_user.id
      return
    end
    @messages = @dialog.messages.includes(:from_user).paginate(:page => params[:page], :per_page => 10)
    current_user.read_messages(@dialog, @messages)
    set_seo_meta("#{current_user.login} - 私信")
  end


  def create
  end

  def send_message
    begin
      message = Message.post(current_user.id, params[:to_user_id], params[:content])
      respond_to do |format|
        format.js { render :text => { :success => true }.to_json }
        format.html { redirect_to :back }
      end
    rescue => e
      p e.inspect
      render :text => { :success => false }.to_json
    end
  end
  
end