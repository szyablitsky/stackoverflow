$ ->
  $('.vote a').tooltip()

  $('main')

  .on 'ajax:success', '.vote a', (e, data, status, xhr) ->
    data = $.parseJSON(xhr.responseText)
    $vote = $(this).parent().parent()

    $vote.find('a').addClass('disabled').removeAttr('data-remote')
    .removeAttr('data-type').removeAttr('data-method')
    .attr('href','javascript:void(0)').tooltip('destroy')
    .attr('title',"You already voted for this #{data.type}").tooltip()

    $vote.find('.score').text(data.score)

  .on 'ajax:error', '.vote a', (e, xhr, status, error) ->
    console.log(error)
