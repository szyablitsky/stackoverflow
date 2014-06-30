class TopicDecorator < Draper::Decorator
  delegate_all

  def votes_label
    object.question.score == 1  ? 'vote' : 'votes'
  end

  def answers_class
    'empty' unless object.has_answers?
  end

  def answers_label
    object.answers_count == 1 ? 'answer' : 'answers'
  end

  def views_label
    object.views == 1 ? 'view' : 'views'
  end

  def message_id_by(user)
    "#message-#{answer_id_by user}"
  end

  def tags_list
    tags_array = tags.to_a
    tags_array.map! do |tag|
      "<span class=\"label label-info\">#{tag.name}</span>"
    end
    tags_array.join(' ').html_safe
  end
end
