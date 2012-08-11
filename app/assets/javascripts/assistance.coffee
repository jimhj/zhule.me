Zhule.Assistance = 
  init : ->
    this.__replyToAssist()
    this.__commentToAssist()
    this.__deleteComment()
    this.__markAsHelpful()
    this.__enLargePhoto()

  __replyToAssist : ->
    $('a.helpWhom').click ->
      $helpForm = $(this).parents('.assistance_detail').next()
      return if $(this).is('.gray')
      if $helpForm.is(':hidden')
        $helpForm.slideDown()
      else
        $helpForm.slideUp()

    $('.i_can_help a.submit').click ->
      $this = $(this)
      return if $this.is('.gray')
      $textarea = $(this).prev()
      assistance_id = $textarea.data('assistance_id')
      url = "/assistances/#{assistance_id}/join"
      content = $textarea.val()
      if $.trim(content) == 0
        Zhule.tips('先跟TA说的什么吧～')
      else
        $.post(url, { content : content }, (data) ->
          if data.success
            window.location.reload()
        , 'json')


  __commentToAssist : ->
    $('a.postComment').click -> 
      $this = $(this)
      $textarea = $this.prev('textarea')
      content = $textarea.val()
      if $.trim(content).length == 0
        Zhule.tips('请输入评论内容')
      else
        commentable_id = $this.attr('data-commentable_id')
        commentable_type = $this.attr('data-commentable_type')
        paramters = { commentable_id : commentable_id, commentable_type : commentable_type, content : content }
        $.post '/comments', paramters, (data) ->
          if data.success
            $('.comt_list').empty() if $('.comt_list').find('.comt_li').length == 0
            $('.comt_list').append $(data.html)
            $('abbr:last').text('刚刚');
            $textarea.val('').focus()
          else
            Zhule.tips data.msg
        , 'json'

  __deleteComment : ->
    $('.comt_list').on 'click', 'a.deleteComment', ->
      $this = $(this)
      comment_id = $this.attr('data-comment_id')
      $.ajax
        url: "/comments/#{comment_id}"
        type: 'DELETE'
        dataType: 'json'
      .done (data) ->
        $this.parents('.comt_li').remove() if data.success

  __markAsHelpful : ->
    $('a.markAsHelpful').click ->
      $this = $(this)
      return if $this.is('.gray')
      paramters = { id : $this.attr('data-help_id') } 
      $.post '/assistances/mark_as_helpful', paramters, ->
        $this.addClass('gray')

  __enLargePhoto : ->
    $loading = $('<img src="/assets/loading.gif"/>')

    resizeImg = (img) -> 
      w = img.width
      h = img.height
      $img = $(img).addClass('large')

      if w > 570
        $img.css('width', 570).css('height', 570 * h / w)
      $img.addClass('large')
      return $img

    $('.pics').on 'click', 'img', ->
      $this = $(this)
      if $this.is('.small')
        $this.hide().after($loading)
        img = new Image()
        img.src = $this.data('large_url')

        if img.complete
          $loading.remove()
          $img = resizeImg(img)
          $this.after($img)
        else
          img.onload = ->
            $loading.remove()
            $img = resizeImg(img)
            $this.after($img)
            img.onload = null           
      else
        $('img.small').show()
        $this.remove()


$(document).ready ->
  Zhule.Assistance.init()