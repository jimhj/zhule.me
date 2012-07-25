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

  # scope :find_by_assistance_id, lambda { |assistance_id| where(:assistance_id => assistance_id).first }

end