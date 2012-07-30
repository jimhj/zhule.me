# coding: utf-8
class DialogsController < ApplicationController
  layout 'home'
  before_filter :require_login

  def index
    @dialogs = Dialog.where(:to_user_id => current_user.id).includes(:from_user)
  end

  def show
    @dialog = Dialog.where(:_id => params[:id]).first
    unless @dialog.to_user_id == current_user.id
      return
    end
    @messages = @dialog.messages
  end

  def read_messages
    @dialog = Dialog.where(:_id => params[:id]).first
    # Don't know why it's not working.
    # Message.where(:dialog_id => params[:id]).update_all('readed' => true)
    @dialog.messages.each do |msg|
      msg.readed = true
      msg.save
    end
    @dialog.to_user.update_attribute(:messages_count, 0)
    render :nothing => true
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