Zhule.OAuth = 
  init : ->
    this.__createOauthUser()

  __createOauthUser : ->
    $('#newWeiboUserForm').find('a.submit').click ->
      email = $('.set_email').find('input').val()
      if $.trim(email).length > 0
        $(this).parents('form')[0].submit()

Zhule.SignUp = 
  init : ->
    this.__createUser()

  __createUser : ->
    $('#newUserForm').find('a.submit').click ->
      $(this).parents('form')[0].submit()

Zhule.SignIn = 
  init : ->
    this.__signIn()

  __signIn : ->
    $('#loginForm').find('input.email').focus ->
      $this = $(this)
      $this.val('') if $this.val() == $this.attr('init_text')
    .blur ->
      $this = $(this)
      $this.val($this.attr('init_text')) if $this.val() == ''

    $('#loginForm').find('input.password_init').focus ->
      $(this).hide()
      $(this).next().show().focus()

    $('#loginForm').find('input.password').blur ->
      $this = $(this)
      if $this.val() == ''
        $this.hide()
        $this.prev().show()
    .keyup (e) ->
      if e.keyCode == 13
        $(this).parents('form')[0].submit()

    $('#loginForm').find('a.submit').click ->
      $form = $(this).parents('form')
      if $form.find('input.email').val() != $form.find('input.email').attr('init_text')
        $form.submit()
 

$(document).ready ->
  Zhule.SignUp.init()
  Zhule.SignIn.init()
  Zhule.OAuth.init()