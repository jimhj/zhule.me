# coding: utf-8

class UserFollow
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::CounterCache

  belongs_to :user
  counter_cache :name => :user, :inverse_of => :followers

  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  counter_cache :name => :follower, :inverse_of => :fans

  validates_uniqueness_of :user_id, :scope => :follower_id

  index :user_id => 1
  index :follower_id => 1
  index :created_at => -1

  before_save do
    return false if user_id == follower_id
  end

end
