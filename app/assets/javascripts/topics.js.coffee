$ ->
  PrivatePub.subscribe '/topics/new', (data, channel) ->
    console.log data
    $questions = $('#questions')
    topicHtml = JST['topic'](data)

    $questions.prepend(topicHtml).children().first()
      .animate {backgroundColor:'lightblue'}, 300
      .animate {backgroundColor:'white'}, 1700
    remove = $questions.children().length - 20
    while remove > 0
      $questions.children().last().remove()
      remove -= 1
