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

  def create
  end

  def send_message
    dialog = Dialog.where(:_id => params[:id]).first
    message = Message.post(current_user.id, dialog.from_user_id, params[:content])
    redirect_to dialog_path(params[:id])
  end
  
end