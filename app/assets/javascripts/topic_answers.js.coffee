$ ->
  cleanup = () ->
    $('.accept-answer-link').removeClass 'disabled'
    $('.accept-answer').remove()

  $('main')

  .on 'click', '.accept-answer-link', (e) ->
    $link = $(this)
    return if $link.hasClass 'disabled'
    cleanup()
    $link.addClass 'disabled'
    data =
      questionId: $link.data 'questionId'
      answerId: $link.data 'answerId'
    acceptHtml = JST['accept'](data)
    $link.parent().after acceptHtml
    $('.accept-answer').slideDown()

  .on 'click', '.cancel-accept-answer', (e) -> cleanup()

  .on 'click', '.answer-link', (e) ->
    href = $(this).attr('href').match(/(#.+)/)[0]
    $(href).stop()
      .animate({backgroundColor: 'lightblue'}, 300)
      .animate({backgroundColor: 'white'}, 1700)
