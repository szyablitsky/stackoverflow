$ ->
  $('main').on 'click', '.add-comment', (e) ->
    e.preventDefault()
    if $(this).hasClass('disabled')
      alert = $(this).next('.alert').removeClass('hidden')
      alert.on 'click', 'button.close', -> alert.addClass('hidden')
    else
      $(this).hide().siblings('form').show()
  $('main').on 'click', '.cancel-comment', (e) ->
    e.preventDefault()
    $(this).parent().hide().siblings('a').show()
