class TopicDecorator < Draper::Decorator
  delegate_all

  def votes_label
    'votes'
  end

  def answers_class
    'empty' if object.answers.count.zero?
  end

  def answers_label
    object.answers.count == 1 ? 'answer' : 'answers'
  end

  def views_label
    object.views == 1 ? 'view' : 'views'
  end

  def message_id_by(user)
    id = answers.where(author: user).first.id
    "#message-#{id}"
  end
end
