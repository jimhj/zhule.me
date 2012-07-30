# coding: utf-8
class CommentsController < ApplicationController
  before_filter :require_login

  def create
    commentable = params[:commentable_type].camelize.safe_constantize.where(:_id => params[:commentable_id]).first
    comment = commentable.comments.build(
      :user_id              => current_user.id,
      :commentable_id       => params[:commentable_id],
      :commentable_type     => params[:commentable_type],
      :content              => params[:content]
    )
    if comment.save
      html_str = render_to_string(:partial => 'comments/comment', :locals => { :comment => comment })
      render :text => { :html => html_str, :success => true }.to_json
    else
      render :text => { :success => false, :msg => '评论发表失败！' }.to_json
    end
  end

  def destroy
    comment = Comment.where(:_id => params[:id]).first
    return if comment.user_id != current_user.id
    if comment.destroy
      render :text => { :success => true }.to_json
    end
  end

end