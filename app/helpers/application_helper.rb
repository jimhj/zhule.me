# coding: utf-8
module ApplicationHelper

  def message_link_tag(user, opts = {}, &block)
    return '' unless logged_in? 
    options = { :class => 'sendMsgBtn', :link_text => '私信', :title => "向#{user.login}发送私信" }.merge(opts)
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

  def user_hearts_tag(user)
    helps_count = user.helped_stuffs_count
    helpfuls_count = user.assistance_helpers.helpful_assistance.count
    icons_tag = "<i class='icons icons_heart'></i>"

    if helpfuls_count <= 5
      if helps_count > 0
        total = icons_tag
      else
        total = "<span>还没有帮过任何人呢...</span>"
      end
    elsif helpfuls_count > 5 && helpfuls_count <= 15
      total = icons_tag * 2
    elsif helpfuls_count > 15 && helpfuls_count <= 25
      total = icons_tag * 3
    elsif helpfuls_count > 25 && helpfuls_count <= 35
      total = icons_tag * 4
    elsif helpfuls_count > 35
      total = icons_tag * 5
    end

    total.html_safe
  end

end
