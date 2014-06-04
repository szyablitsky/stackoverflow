$ ->
  if $('#topic_tags').length > 0
    $.get '/tags.json', (data) ->
      $('#topic_tags').select2
        tags: data
        tokenSeparators: [",", " "]

  $('main')
  
  .on 'focus', '.select2-container input', (e) ->
    $(this).closest('.select2-choices').addClass('focus')

  .on 'blur', '.select2-container input', (e) ->
    $(this).closest('.select2-choices').removeClass('focus')
