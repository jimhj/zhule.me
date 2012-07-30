Zhule.Dialog = 
  init : ->
    this.__readDialog()

  __readDialog : ->
    if $('.readDialog').length == 1
      dialog_id = $('.readDialog').data('dialog_id')
      $.post "/dialogs/#{dialog_id}/read_messages"


$(document).ready ->
  Zhule.Dialog.init()