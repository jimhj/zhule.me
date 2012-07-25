#= require jquery
#= require jquery_ujs
Zhule = window.Zhule = {}
Zhule.SiteHeader = 
  init : ->
    this.__toggleDropDown()
    this.__followUser()

  __toggleDropDown : ->
    $('.site-header .logged-in .options').mouseenter ->
      $this = $(this)
      $this.addClass('active')
      $this.find('.dropdown-list').show()
    .mouseleave ->
      $this = $(this)
      $this.removeClass('active')
      $this.find('.dropdown-list').hide()

  __followUser : ->
    $('a.followBtn').click ->
      follower_id = $(this).data('user_id')
      url = "/users/#{follower_id}/follow"
      $.post(url, (data) ->
        if data.success
          $(this).addClass('gray')
      ,'json')



$(document).ready ->
  Zhule.SiteHeader.init()