Zhule.Home = 
  init : ->
    this.Assistance.init()
    this.Message.init()

Zhule.Home.Assistance =  
  init : ->
    this.__newAssistance()

  __newAssistance : ->
    $form = $('#newAssistance')
    

    $('a.location').click ->
      $this = $(this)
      $attach = $('.attachment_panel.address')
      if $attach.is(':hidden')
        $attach.find('input').val $('.attachment_panel.address').find('input').val()
        $attach.show()
      else
        $attach.hide()

    $('a.uploadImage').click ->
      $attach = $('.attachment_panel.photo')
      if $attach.is(':hidden')
        $attach.show()
      else
        $attach.hide()

    $('.attachment_panel.address').find('a.submit').click ->
      $this = $(this)
      address = $this.prev('input').val()
      if $.trim(address).length > 0 && $.trim(address).length < 20
        $('a.location').find('span').text(address)
        $this.closest('.attachment_panel').hide()

    $('.attachment_panel.photo').find('a.submit').click ->
      $this = $(this)
      $file = $this.prev('input')
      if $file.val()?
        $this.parents('form').ajaxSubmit(
          dataType: 'json'
          beforeSend: ->
            $('a.uploadImage').find('span').text('正在上传...')
          success: (data) ->
            if data.success
              $('a.uploadImage').find('span').text(data.photo_name)
              $('#newAssistance').find('textarea').data('attachment_id', data.id)
              $this.closest('.attachment_panel').hide()
            else
              $('a.uploadImage').find('span').text('上传图片')
        )

    $('a.button.gray').click ->
      $(this).closest('.attachment_panel').hide()
      if $(this).closest('.attachment_panel').is('.address')
        $('a.location').find('span').text('地点')
        $('.attachment_panel.address').find('input').val('')
      else
        $('a.uploadImage').find('span').text('上传图片')
        $('#newAssistance').find('textarea').data('attachment_id', '')

    $form.find('a.submit').click -> 
      $this = $(this)
      content = $form.find('textarea').val()
      if content.length < 10
        Zhule.tips('字数是不是太少啦？')
      else
        address = $('.attachment_panel.address').find('input').val()
        attachment_id = $form.find('textarea').data('attachment_id')
        paramters = { content : content, address : address, attachment_id : attachment_id }
        $.post '/assistances', paramters, (data) ->
          if data.success
            Zhule.tips('发表求助成功！')
            $form.find('textarea').val('')
            window.location = window.location
        , 'json'

Zhule.Home.Message = 
  init : ->
    this.__newMessage()

  __newMessage : ->
    $form = $('#newMessageForm')
    $form.find('a.submit').click ->

      content = $form.find('textarea').val()
      $form[0].submit() if content.length > 0

 

$(document).ready ->
  Zhule.Home.init()
