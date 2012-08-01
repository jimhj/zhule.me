# coding: utf-8
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::CounterCache
  include Mongoid::DelayedDocument

  field :content
  belongs_to :commentable, :polymorphic => true
  counter_cache :name => :commentable, :inverse_of => :comments
  
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }

  index({ :commentable_type => 1, :commentable_id => 1 })
  index :created_at => -1
  index :user_id => 1

  after_create do
    return false if self.user_id == self.commentable.user_id
    Comment.perform_async(:send_notification, self._id)
  end

  def self.send_notification(comment_id)
    comment = self.where(:_id => comment_id).first
    Notification::AssistanceComment.create :user_id             => comment.commentable.user_id, 
                                           :commentable_id      => comment.commentable_id,
                                           :commentable_type    => comment.commentable_type,
                                           :comment_id          => comment._id    
  end

  after_destroy do
    Notification::AssistanceComment.destroy_all(:comment_id => self._id)
  end

end