# coding: utf-8
module ApplicationHelper

  def message_link_tag(user, opts = {}, &block)
    options = { :class => 'sendMsgBtn', :link_text => '私信' }.merge(opts)
    link_text = options.delete(:link_text)
    options.merge!({ 'data-user_id' => user.id, 'data-user_name' => user.login })
    options[:class] << ' sendMsgBtn' unless options[:class].include?('sendMsgBtn')
    link_to 'javascript:;', options do
      if block_given?
        yield
      else
        "<i class='icons icons_mail'></i>#{link_text}".html_safe
      end
    end
  end

end
