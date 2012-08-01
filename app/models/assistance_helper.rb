# coding: utf-8
class AssistanceHelper
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CounterCache
  include Mongoid::DelayedDocument

  field :helpful, :type => Boolean, :default => false
  field :content

  belongs_to :user
  counter_cache :name => :user, :inverse_of => :helped_stuffs

  belongs_to :assistance
  counter_cache :name => :assistance, :inverse_of => :helpers

  validates_uniqueness_of :user_id, :scope => :assistance_id

  index :user_id => 1
  index :assistance_id => 1

  before_create do
    return false if self.user_id == self.assistance.user_id
  end

  after_create do
    self.class.perform_async(:send_join_notification, self._id)
  end

  after_save do
    if self.helpful
      self.class.perform_async(:send_assist_notification, self._id)
    end
  end

  def self.send_join_notification(assistance_helper_id)
    assistance_helper = AssistanceHelper.where(:_id => assistance_helper_id).first
    Notification::JoinAssistance.create :user_id                 => assistance_helper.assistance.user_id, 
                                        :assistance_id           => assistance_helper.assistance_id,
                                        :assistance_helper_id    => assistance_helper._id    
  end

  def self.send_assist_notification(assistance_helper_id)
    assistance_helper = AssistanceHelper.where(:_id => assistance_helper_id).first
    Notification::Assist.create :user_id                 => assistance_helper.user_id, 
                                :assistance_id           => assistance_helper.assistance_id,
                                :assistance_helper_id    => assistance_helper._id       
  end

end