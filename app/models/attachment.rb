# coding: utf-8
class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :user, :index => true
  belongs_to :attachmentable, :polymorphic => true
  mount_uploader :photo, PhotoUploader

  index({ :attachmentable_type => 1, :attachmentable_id => 1 }) 
  index :user_id => 1
  
end