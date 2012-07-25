# coding: utf-8
class Assistance
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CounterCache

  field :content
  field :address, :type => String, :default => ''
  field :assist_public, :type => Boolean, :default => true
  field :pictures, :type => Array, :default => []
  field :solved, :type => Boolean, :default => false
  field :ask_to, :type => Array, :default => []

  field :helpers_count, :type => Integer, :default => 0

  index :user_id => 1

  validates_presence_of :content

  belongs_to :user, :inverse_of => :assistances
  counter_cache :name => :user, :inverse_of => :assistances

  has_many :assistance_helpers
  has_many :comments, :as => :commentable


end