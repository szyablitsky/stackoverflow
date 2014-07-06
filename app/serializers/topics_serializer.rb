class TopicsSerializer
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(topic)
    @topic = topic
  end

  def to_hash(options)
    self.send "to_#{options[:type]}_hash".to_sym
  end

  def self.to_hash(collection)
    {
      timestamp: collection.last.created_at,
      questions: collection.map { |topic| self.new(topic).to_hash type: :api_collection }
    }
  end

  private

  def to_api_collection_hash
    question = MessagesSerializer.new(@topic.question).to_hash type: :api_collection
    question.delete :id
    { id: @topic.id, title: @topic.title }.merge question
  end

  def to_api_resource_hash
    collections = MessagesSerializer.new(@topic.question).collections
    collections.merge!({ tags: @topic.tags.map(&:name) })
    { question: to_api_collection_hash.merge(collections) }
  end

  def to_private_pub_hash
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
