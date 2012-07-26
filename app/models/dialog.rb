# coding: utf-8
class Dialog
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CounterCache

  field :from_user_id
  field :to_user_id

  field :last_reply_user_login
  field :last_reply_user_id
  field :last_reply_content

  field :readed, :type => Boolean, :default => false

  field :messages_count, :type => Integer, :default => 0

  belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
  belongs_to :to_user, :class_name => 'User', :foreign_key => 'to_user_id'
  counter_cache :name => :to_user, :inverse_of => :dialogs

  embeds_many :messages

  default_scope desc('created_at')

  index :to_user_id => 1
  index :from_user_id => 1
  index :updated_at => -1

  # def self.create_dialog(current_user_id, to_user_id)
  #   self.transaction do
  #     self_dialog = self.find_or_create_by(:from_user_id => current_user_id, :to_user_id => to_user_id)
  #     other_dialog = self.find_or_create_by(:from_user_id => to_user_id, :to_user_id => current_user_id)
  #     return self_dialog, other_dialog
  #   end
  # end

end