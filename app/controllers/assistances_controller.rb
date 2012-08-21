# coding: utf-8
class AssistancesController < ApplicationController
  layout 'assistance'
  before_filter :require_login, :except => [:show, :joined]
  skip_before_filter :verify_authenticity_token, :only => :upload_photo

  def new
    @user = current_user
    render :template => 'assistances/new_assistance_form', :layout => false
    # respond_to do |format|
    #   format.html { redirect_to home_path }
    #   format.js {
    #     render :template => 'assistances/new_assistance_form'
    #   }
    # end
  end

  def show
    @assist = Assistance.where(:_id => params[:id]).first
    @user = @assist.user
    set_seo_meta(@assist.content.truncate(50), nil, @assist.content)
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
        format.js { render :text => { :success => assist.save, :id => assist._id }.to_json }
      end
    rescue
      render :text => { :success => false }.to_json
    end
  end

  def edit
    @assist = Assistance.where(:_id => params[:id]).first
    @user = @assist.user
    return if current_user != @user
    @address = @assist.address
    @address = '地点' if @address.blank?
    @filename = '上传图片'
    @attachment = @assist.attachments.first
    @filename = @attachment.photo_filename if @attachment.present?
  end

  def update
  end

  def joined
    @assist = Assistance.where(:_id => params[:id]).first
    set_seo_meta(@assist.content.truncate(30), nil, @assist.content.truncate(30))
    @user = @assist.user
    @helpers = @assist.assistance_helpers.includes(:user)
  end

  def join
    assistance_helper = current_user.assistance_helpers.build(:assistance_id => params[:id], :content => params[:content])
    expire_fragment('newest_helps')
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