# coding: utf-8
require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  field :email, :type => String, :default => ''
  field :login, :type => String, :default => ''
  field :password_digest, :type => String
  field :avatar, :type => String, :default => ''
  field :address, :type => String, :default => ''
  field :last_logged_at, :type => Time
  field :tags, :type => Array, :default => []
  field :tagline 
  
  field :assistances_count, :type => Integer, :default => 0
  field :helped_stuffs_count, :type => Integer, :default => 0
  field :notifications_count, :type => Integer, :default => 0
  field :messages_count, :type => Integer, :default => 0
  field :followers_count, :type => Integer, :default => 0
  field :fans_count, :type => Integer, :default => 0

  index({ :email => 1 }, { :unique => true })

  has_many :assistances
  has_many :assistance_helpers
  has_many :notifications, :class_name => 'Notification::Base', :dependent => :delete
  has_many :user_follows
  has_many :attachments

  validates :email, :presence => true, 
                    :uniqueness => true,
                    :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }

  validates :login, :presence => true, :length => { :minimum => 2, :maximum => 20 }

  validates_length_of :tagline, :maximum => 100
  validates_presence_of :password
  validates_confirmation_of :password

  attr_accessible :email, :login, :password, :password_confirmation
  attr_accessible :avatar, :avatar_cache
  mount_uploader :avatar, AvatarUploader

  def tag_list=(value)
    self.tags = value.split(/,|，/) if !value.blank?
  end

  def tag_list
    self.tags.join(",")
  end

  def password
    if password_digest.present?
      @password ||= Password.new(password_digest)
    end
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password    
  end

  def helped?(assist_id)
    self.assistance_helpers.find_by(:assistance_id => assist_id).present?
  end

  def followed?(user_id)
    self.user_follows.find_by(:follower_id => user_id).present?
  end

  def read_notifications(notifications)
    unread_ids = notifications.find_all{ |notification| !notification.readed? }.map(&:_id)
    if unread_ids.any?
      Notification::Base.where({
        :user_id => self.id,
        :_id.in  => unread_ids,
        :readed    => false
      }).update_all(:readed => true)
    end
  end

  def read_messages(messages)
    unread_ids = messages.find_all{ |message| !message.readed? }.map(&:_id)
    Message.where({ :user_id => self.id, :_id.in => unread_ids }).update_all(:readed => true)
    self.update_attribute(:messages_count, 0)
  end

  def unread_notifications_count
    self.notifications.where(:readed => false).count
  end

  class << self
    def authenticate(email, password)
      user = self.where(:email => email).first
      return nil if user.nil?
      user.password == password ? user : nil
    end
  end


end