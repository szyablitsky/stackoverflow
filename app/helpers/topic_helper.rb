module TopicHelper
  def answer_path(answer)
    "#{question_path(answer['topic_id'])}/#message-#{answer['message_id']}"
  end
end
