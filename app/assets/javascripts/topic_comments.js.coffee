cleanup = (form) ->
  form.find('textarea,input[type="text"],input[type="file"]').val('')
  form.find('.form-group').removeClass('has-error')
  form.find('.help-block').remove()
  form

render = (comment) ->
  comment_id = "#comment-#{comment.id}" 
  return if $(comment_id).length > 0
 
  message = $("#message-#{comment.message_id}")
  list = message.find('.comments-list')
  commentHtml = JST['comment'](comment)
  list.append(commentHtml).find('time').timeago()
  $(comment_id).stop()
    .animate({backgroundColor:'lightblue'}, 300)
    .animate({backgroundColor:'white'}, 1700)

$ ->
  $('main')

  .on 'click', '.add-comment', (e) ->
    e.preventDefault()
    if $(this).hasClass('disabled')
      alert = $(this).siblings('.alert')
      if alert.length == 0
        $(this).after( JST['alert/comment']() )
      else
        alert.effect('bounce')
    else
      messageId = $(this).data('messageId')
      $('.add-comment').show() # all other links
      $form = $('#new_comment').detach()
      cleanup($form)
      $form.attr('action',"/messages/#{messageId}/comments")
      $(this).hide().after($form)
      $form.show()

  .on 'click', '.cancel-comment', (e) ->
    e.preventDefault()
    $(this).parent().hide().siblings('a').show()

  .on 'ajax:success', '#new_comment', (evt, data, status, xhr) ->
    $form = $(this)
    cleanup($form).hide()
    $form.parent().find('.add-comment').show();
    render $.parseJSON(xhr.responseText)

  .on 'ajax:error', '#new_comment', (evt, xhr, status, error) ->
    $form = $(this)
    cleanup $form
    errors = $.parseJSON(xhr.responseText)
    for own key, value of errors.errors
      group = $form.find("#comment_#{key}").parent()
      group.addClass('has-error')
      group.append( JST['field_error']({error: value}) )

  channel = "/topics/#{$('#topic-id').data('id')}/comments"
  PrivatePub.subscribe channel, (data, channel) -> render data
