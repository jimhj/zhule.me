Zhule.Setting = 
  init : ->
    $form = $('#settingForm')
    $form.find('a.submit').click ->
      # for IE6
      $('#settingForm')[0].submit()

    Zhule.Setting.Basic.init()
    # Zhule.Setting.Avatar.init()
    return

Zhule.Setting.Basic =
  init : ->
    return

Zhule.Setting.Avatar = {}


$(document).ready ->
  Zhule.Setting.init() 
