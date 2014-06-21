module TopicHelper
  def answer_path(answer)
    "#{question_path(answer['topic_id'])}/#message-#{answer['message_id']}"
  end

  def markdown(source)
    @renderer ||= Redcarpet::Render::HTML.new(escape_html: true)
    @markdown ||= Redcarpet::Markdown.new(@renderer, autolink: true)
    @markdown.render(source).html_safe
  end
end
