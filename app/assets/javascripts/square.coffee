Zhule.Square = 
  init : () ->
    this.__bindInitWaterfall()
  __loadTimes : 0

  __bindInitWaterfall : () ->
    self = this
    self.__loadTimes = 0
    self.__loadWaterfall()

  __loadWaterfall : () ->
    self = this
    $.get '/square/load_square_columns', (data) ->
      $html = $(data.html_str)
      $html.each ->
        $(this).find('abbr').timeago()
        $(this).find('a[rel=tipsy]').tipsy(fade: false, gravity: 's')
        $(this).appendTo(minColumn())

      self.__loadTimes += 1
    , 'json'

    minColumn = ->
      h = [
        $('.col_0').height(),
        $('.col_1').height(),
        $('.col_2').height(),
        $('.col_3').height()
      ]

      min_h = Math.min.apply(null, h);

      for _h, i in h when min_h == _h
        return $(".col_#{i}")

      return $('.col_0')


$(document).ready ->
  Zhule.Square.init()


