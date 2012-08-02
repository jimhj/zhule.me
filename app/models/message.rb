# coding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created  
  include Mongoid::CounterCache
  include Mongoid::DelayedDocument

  field :content
  field :sender_id
  field :receiver_id
  field :readed, :type => Boolean, :default => false

  embedded_in :dialog
  counter_cache :name => :dialog, :inverse_of => :messages

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  validates :content, :presence => true, :length => { :maximum => 140 }

  index :receiver_id => 1
  index :created_at => -1

  default_scope desc('created_at')

  def self.post(sender_id, receiver_id, content)
    return if sender_id == receiver_id
    other_dialog = Dialog.find_or_create_by(:from_user_id => receiver_id, :to_user_id => sender_id)
    params = { :content => content, :sender_id => sender_id, :receiver_id => receiver_id }
    other_dialog.messages.create(params)
    self.perform_async(:send_message_to_self, params)
  end

  def self.send_message_to_self(opts)
    self_dialog = Dialog.find_or_create_by(:from_user_id => opts['sender_id'], :to_user_id => opts['receiver_id'])
    self_dialog.messages.create(opts)
    User.where(:_id => opts['receiver_id']).first.inc(:messages_count, 1)    
  end

  after_create do
    self.dialog.update_attributes(
      :last_reply_user_id       => self.sender_id,
      :last_reply_user_login    => self.sender.login,
      :last_reply_content       => self.content,
      :updated_at               => self.created_at
    )


  end

end