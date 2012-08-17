Zhule.AssistPopup =
  init : () ->
    this.__bindNewAssistClickEvent()

  __bindNewAssistClickEvent : () ->
    # Bind event.
    $('body').on 'click', '.f_upload_notify a', ->
      $this = $(this)
      $upload_panel = $this.parent().next()
      if $upload_panel.is(':hidden')
        $upload_panel.slideDown()
      else
        $upload_panel.slideUp()
        
    # Bind file input click event.
    .on 'click', '.f_upload_panel a', ->
      $this = $(this)
      $this.next().click()
    .on 'click', '.f_buttons a.button', ->
      $this = $(this)
      $detail = $('.f_detail textarea.form_text')
      if $.trim($detail.val()).length < 10
        Zhule.tips('字数太少了吧？')
      else
        paramters = 
          content: $detail.val()
          address: $('.f_addr input').val()
          attachment_id: $detail.data('attachment_id')
        $.post '/assistances', paramters, (data) ->
          if data.success
            Zhule.tips('发表求助成功！')
            window.location = "/assistances/#{data.id}"
          else
            Zhule.tips('出错了，正在为您转跳...')
            window.location.reload()
        , 'json'

    .on 'change', 'input:file', ->
      $this = $(this)
      if $this.val()?
        $this.parents('.f_upload_panel').find('form').ajaxSubmit(
          dataType: 'json'
          beforeSend: ->
            $this.after('<span>正在上传...</span>') 
          success: (data) ->
            if data.success
              name = if data.photo_name.length > 30 then data.photo_name.slice(0, 30) + '...' else data.photo_name
              $this.next('span').text(name)
              $('.f_detail textarea.form_text').data('attachment_id', data.id)
            else
              $this.next('span').text('上传图片失败，请重试')
        )      
      
           
    $('.newAssistance').click ->
      render_assist_form = ->
        $form = $('<div class="newAssistanceForm"></div>')
        $detail = $('<div class="f_detail"><textarea class="form_text" style="width: 380px; height: 80px;" data-attachment_id=""></textarea></div>')
        $attachment = $('<div class="f_attachment"></div>')
        $attach_notify = $('<div class="f_upload_notify"><a href="javascript:;"><i class="icons icons_img"></i>上传图片附件</a></div>')
        $upload_panel = $('<div class="f_upload_panel">
          <form action="/assistances/upload_photo" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
            <a href="javascript:;" class="button green">点击选择图片</a>
            <input type="file" style="font-size: 0;height: 0;width: 0;" name="photo"/>
          </form>
        </div>')
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