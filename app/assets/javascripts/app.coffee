#= require jquery
#= require jquery_ujs
#= require lib/artdialog/artDialog
#= require lib/artdialog/plugins/iframeTools
#= require lib/jquery.tipsy 
#= require lib/jquery.timeago
#= require lib/jquery.timeago.zh-CN
#= require lib/jquery.form

Zhule = window.Zhule = {}
Zhule.tips = (msg) ->
  art.dialog.tips("<span style='color: #999;font-size: 12px;'>#{msg}</span>")

Zhule.CommonEvents = 
  init : ->
    this.__bindJqueryTimeago()
    this.__toggleDropDown()
    this.__followUser()
    this.__bindJqueryTipsy()
    # this.__showMessengerBtn()

  __bindJqueryTipsy : ->
    $('a[rel=tipsy]').tipsy 
      fade: false, 
      gravity: 's'

  __bindJqueryTimeago : ->
    $('abbr.timeago').timeago()

  __toggleDropDown : ->
    $('.site-header .logged-in .options').mouseenter ->
      $this = $(this)
      $this.addClass('active') unless $this.is('.without_hover')
      $this.find('.dropdown-list').show()
    .mouseleave ->
      $this = $(this)
      $this.removeClass('active')
      $this.find('.dropdown-list').hide()

  __showMessengerBtn : ->
    $('.avatar').mouseenter ->
      $(this).find('.sendMsgBtn').css('visibility', 'visible')
    .mouseleave ->
      $(this).find('.sendMsgBtn').css('visibility', 'hidden')

  __followUser : ->
    $('a.followBtn').click ->
      $this = $(this)
      follower_id = $this.data('user_id')
      url = "/users/#{follower_id}/follow"
      return if $this.is('.gray')
      $.post(url, (data) ->
        if data.success
          $this.addClass('gray')
          $this.text('已关注')
      ,'json')

Zhule.Messenger = 
  init : ->
    this.__messengerPopup()

  __messengerPopup : ->
    genMsgDom = (msg_to) ->
      $msgDom = $('<div class="popUp msgDom"></div>')
      $msgTo = $('<p class="notify"> 我对 <span></span> 说：</p>')
      $msgTo.find('span').text(msg_to)
      $msgInput = $('<div class="msgInput"><textarea class="form_text msgText" /></div>')
      $msgInput.find('textarea').css { width: '400px', height: '80px' }
      $msgDom.append $msgTo, $msgInput
      return $msgDom

    $('a.sendMsgBtn').click ->
      user_name = $(this).data('user_name')
      user_id = $(this).data('user_id')
      dialog = art.dialog
        content: genMsgDom(user_name)[0]
        title: '发送私信'
        fixed: true
        lock: true
        id: 'sendMsg'
        okVal: '发送'
        ok: () ->
          text = $('textarea.msgText').val()
          return if $.trim(text).length == 0
          paramtes = 
            content: text
            to_user_id: user_id
          $.post '/dialogs/send_message', paramtes, (data) ->
            if data.success
              Zhule.tips('私信已发送！')
          , 'json'
        cancel: true





$(document).ready ->
  Zhule.CommonEvents.init()
  Zhule.Messenger.init()