Zhule.SignUp = 
  init : ->
    this.__createUser()

  __createUser : ->
    $('#newUserForm').find('a.submit').click ->
      $(this).parents('form').submit()

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
        $(this).parents('form').submit()

    $('#loginForm').find('a.submit').click ->
      $form = $(this).parents('form')
      if $form.find('input.email').val() != $form.find('input.email').attr('init_text')
        $form.submit()
 

$(document).ready ->
  Zhule.SignUp.init()
  Zhule.SignIn.init()