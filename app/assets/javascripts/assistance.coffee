Zhule.Assistance = 
  init : ->
    this.__replyToAssist()

  __replyToAssist : ->
    $('a.helpWhom').click ->
      $helpForm = $(this).parents('.assistance_detail').next()
      return if $(this).is('.gray')
      if $helpForm.is(':hidden')
        $helpForm.slideDown()
      else
        $helpForm.slideUp()

    $('.i_can_help a.submit').click ->
      $textarea = $(this).prev()
      assistance_id = $textarea.data('assistance_id')
      url = "/assistances/#{assistance_id}/join"
      content = $textarea.val()
      if content.length > 0
        $.post(url, { content : content }, (data) ->
          if data.success
            window.location.reload()
        , 'json')

$(document).ready ->
  Zhule.Assistance.init()