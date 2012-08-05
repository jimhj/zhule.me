# coding: utf-8
class AssistancesController < ApplicationController
  layout 'assistance'
  before_filter :require_login

  def index
  end

  def show
    @assist = Assistance.where(:_id => params[:id]).first
    @user = @assist.user
    @assist_helpers = @assist.assistance_helpers.includes(:user).limit(20)
    @comments = @assist.comments.includes(:user).paginate(:page => params[:page], :per_page => 20)
  end

  def create
    @user = current_user
    begin
      assist = @user.assistances.build(:content => params[:content], :address => params[:address])
      if !params[:attachment_id].blank? && assist.save
        attachment = Attachment.where(:_id => params[:attachment_id]).first
        attachment.update_attributes(:attachmentable_type => 'Assistance', :attachmentable_id => assist.id)
      end
      respond_to do |format|
        format.js { render :text => { :success => true }.to_json }
      end
    rescue
      render :text => { :success => false }.to_json
    end
  end

  def joined
    @assist = Assistance.where(:_id => params[:id]).first
    @user = @assist.user
    @helpers = @assist.assistance_helpers.includes(:user)
  end

  def join
    assistance_helper = current_user.assistance_helpers.build(:assistance_id => params[:id], :content => params[:content])
    respond_to do |format|
      format.js { render :text => { :success => assistance_helper.save }.to_json }
    end
  end

  def upload_photo
    photo = current_user.attachments.build(:photo => params[:photo])
    render :text => { :success => photo.save, :id => photo.id, :photo_name => params[:photo].original_filename }.to_json
  end

  def mark_as_helpful
    assistance_helper = AssistanceHelper.where(:_id => params[:id]).first
    assistance_helper.update_attribute(:helpful, true)
    render :nothing => true
  end
  
end