Zhule.Home = 
  init : ->
    this.Assistance.init()
    this.Message.init()

Zhule.Home.Assistance =  
  init : ->
    this.__newAssistance()

  __newAssistance : ->
    $form = $('#newAssistance')
    $form.find('a.submit').click -> 
      content = $form.find('textarea').val()
      if content?
        $.post '/assistances', content : content, (data) ->
          if data.success
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
