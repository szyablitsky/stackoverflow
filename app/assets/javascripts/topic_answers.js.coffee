$ ->
  $('main')

  .on 'click', '.answer-link', (e) ->
    href = $(this).attr('href').match(/(#.+)/)[0]
    $(href).stop()
      .animate({backgroundColor:'lightblue'}, 300)
      .animate({backgroundColor:'white'}, 1700)
