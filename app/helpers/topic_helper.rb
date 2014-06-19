module TopicHelper
  def answer_path(answer)
    "#{question_path(answer['topic_id'])}/#message-#{answer['message_id']}"
  end

  def markdown(source)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                        autolink: true, tables: true)
    @markdown.render(h source).html_safe
  end
end
