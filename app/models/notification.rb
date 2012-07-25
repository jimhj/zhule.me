# coding: utf-8
class Notification
  include Mongoid::Document
  include Mongoid::Timestamps::Created  
  include Mongoid::CounterCache

  field :notify_type
  field :content, :type => Hash, :default => {} 

  belongs_to :user
  counter_cache :name => :user, :inverse_of => :notifications

  index :notify_type => 1
  index :user_id => 1

end