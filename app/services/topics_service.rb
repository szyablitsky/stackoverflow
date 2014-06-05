class TopicsService
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(topic)
    @topic = topic
  end

  def to_hash
    {
      title: @topic.title,
      path: url_helpers.question_path(@topic),
      tags: @topic.tags.map(&:name),
      author: {
        name: @topic.author.name,
        path: url_helpers.user_path(@topic.author),
        reputation: @topic.author.reputation
      }
    }
  end
end
