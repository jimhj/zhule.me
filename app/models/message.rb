# coding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created  
  include Mongoid::CounterCache

  field :content
  field :sender_id
  field :receiver_id

  embedded_in :dialog
  counter_cache :name => :dialog, :inverse_of => :messages

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  validates :content, :presence => true, :length => { :maximum => 140 }

  index :created_at => -1

  default_scope desc('created_at')

  def self.post(sender_id, receiver_id, content)
    return if sender_id == receiver_id
    self.transaction do      
      self_dialog = self.find_or_create_by(:from_user_id => sender_id, :to_user_id => receiver_id)
      other_dialog = self.find_or_create_by(:from_user_id => receiver_id, :to_user_id => sender_id)
      params = { :content => content, :sender_id => sender_id, :receiver_id => receiver_id }
      message = self_dialog.messages.create(params)
      other_dialog.messages.create(params)
      message
    end
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