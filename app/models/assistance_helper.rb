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

  before_save do
    return false if self.user_id == self.assistance.user_id
  end

end