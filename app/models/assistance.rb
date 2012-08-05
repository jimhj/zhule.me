# coding: utf-8
class Assistance
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CounterCache

  field :title
  field :content
  field :address, :type => String, :default => ''
  field :assist_public, :type => Boolean, :default => true
  field :pictures, :type => Array, :default => []
  field :solved, :type => Boolean, :default => false

  field :helpers_count, :type => Integer, :default => 0
  field :comments_count, :type => Integer, :default => 0
  
  validates_presence_of :content

  belongs_to :user, :inverse_of => :assistances
  counter_cache :name => :user, :inverse_of => :assistances

  index :user_id => 1

  has_many :assistance_helpers
  has_many :comments, :as => :commentable
  has_many :attachments, :as => :attachmentable

  default_scope desc(:created_at)


end