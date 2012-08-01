# coding: utf-8

class UserFollow
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::CounterCache
  include Mongoid::DelayedDocument

  belongs_to :user
  counter_cache :name => :user, :inverse_of => :followers

  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  counter_cache :name => :follower, :inverse_of => :fans

  # validates_uniqueness_of :follower_id, :scope => :user_id

  index :user_id => 1
  index :follower_id => 1
  index :created_at => -1

  before_create do
    user_follow = self.class.find_by(:user_id => self.user_id, :follower_id => self.follower_id)
    return !user_follow.present?
  end

  after_create do
    return false if user_id == follower_id
    UserFollow.perform_async(:send_follow_notification, self._id)
  end

  def self.send_follow_notification(user_follow_id)
    user_follow = self.where(:_id => user_follow_id).first
    Notification::Follow.create :user_id => user_follow.follower_id, :user_follow_id => user_follow.id
  end

end
