Zhule.AssistPopup =
  init : () ->
    this.__bindNewAssistClickEvent()

  __bindNewAssistClickEvent : () ->
    $('.newAssistance').click ->
      $('body').on 'click', '.f_upload_notify a', ->
        $this = $(this)
        $upload_panel = $this.parent().next()
        if $upload_panel.is(':hidden')
          $upload_panel.slideDown()
        else
          $upload_panel.slideUp()
      .on 'click', '.f_upload_panel a', ->
        # alert 11111
        $this = $(this)
        $this.next().click()

      render_assist_form = ->
        $form = $('<div class="newAssistanceForm"></div>')
        $detail = $('<div class="f_detail"><textarea class="form_text" style="width: 380px; height: 80px;"></textarea></div>')
        $attachment = $('<div class="f_attachment"></div>')
        $attach_notify = $('<div class="f_upload_notify"><a href="javascript:;"><i class="icons icons_img"></i>上传图片附件</a></div>')
        $upload_panel = $('<div class="f_upload_panel"><a href="javascript:;" class="button green">点击选择图片</a><input type="file" style="font-size: 0;height: 0;width: 0;" /></div>')
        $addr = $('<div class="f_addr"><p><span>填写想要求助的地区</span><input class="text" type="text" /></p></div>')
        $tags = $('<div class="f_tags"><p>填写标签</p><p><input class="text" type="text" /></p></div>')
        $buttons = $('<div class="f_buttons"><a href="javascript:;" class="button">确认</a></div>')

        $attachment.append($attach_notify, $upload_panel)
        # $form.append($detail, $attachment, $addr, $tags, $buttons)
        $form.append($detail, $attachment, $addr, $buttons)
        return $form

      dialog = art.dialog
        title: '发布求助'
        content: render_assist_form()[0]
        lock: true
        fixed: true
        # ok: ->
        # cancel: true




$(document).ready ->
  Zhule.AssistPopup.init() 