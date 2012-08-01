# coding: utf-8
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::CounterCache

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
    Notification::AssistanceComment.create :user_id             => self.commentable.user_id, 
                                           :commentable_id      => self.commentable_id,
                                           :commentable_type    => self.commentable_type,
                                           :comment_id          => self._id
  end  

end