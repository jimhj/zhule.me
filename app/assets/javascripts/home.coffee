Zhule.Home = 
  init : ->
    this.Assistance.init()
    this.Message.init()

Zhule.Home.Assistance =  
  init : ->
    this.__newAssistance()

  __newAssistance : ->
    $form = $('#newAssistance')
    $address = $('<input type="text" class="" style="width: 160px"/>')
    $fileInput = $('<input type="file" />')
    dialog1 = dialog2 = null
    # [addr="北京"][/addr]
    # dialog2 = null

    $form.find('a.location').click ->
      $this = $(this)
      dialog2.close() if dialog2?
      dialog1 = art.dialog
        id: 'postAssist321'
        title: '填写希望获得帮助的地点'
        content: $address[0]
        follow: $this[0]
        drag: false
        resize: false
        ok: ->
          if $.trim($address.val()).length > 1 
            $this.find('span').text($address.val())

    $form.find('a.uploadImage').click ->
      $this = $(this)
      dialog1.close() if dialog1?
      dialog2 = art.dialog
        id: 'postAssist123'
        title: '上传一张图片'
        content: $fileInput[0]
        follow: $this[0]
        drag: false
        resize: false         

    $form.find('a.submit').click -> 
      content = $form.find('textarea').val()
      if content.length < 20
        Zhule.tips('字数是不是太少啦？')
      else
        $.post '/assistances', content : content, (data) ->
          if data.success
            Zhule.tips('发表求助成功！')
            # window.location = window.location
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
