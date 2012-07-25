# coding: utf-8
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::CounterCache

  field :content
  belongs_to :commentable, :polymorphic => true

  index({ :commentable_type => 1, :commentable_id => 1 })
  index :created_at => -1

end