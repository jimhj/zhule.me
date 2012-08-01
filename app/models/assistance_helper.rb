# coding: utf-8
class AssistanceHelper
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CounterCache

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
    Notification::JoinAssistance.create :user_id                 => self.assistance.user_id, 
                                        :assistance_id           => self.assistance_id,
                                        :assistance_helper_id    => self._id
  end

  after_save do
    if self.helpful
      Notification::Assist.create :user_id                 => self.user_id, 
                                  :assistance_id           => self.assistance_id,
                                  :assistance_helper_id    => self._id      
    end
  end

end