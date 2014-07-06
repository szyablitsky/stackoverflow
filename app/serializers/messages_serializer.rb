class MessagesSerializer
  def initialize(message)
    @message = message
  end

  def to_hash(options)
    self.send "to_#{options[:type]}_hash".to_sym
  end

  def self.to_hash(collection)
    {
      timestamp: collection.last.created_at,
      answers: collection.map do |message|
        self.new(message).to_hash type: :api_collection
      end
    }
  end

  def collections
    {
      attachments: attachments,
      comments: comments
    }
  end

  private

  def to_api_collection_hash
    {
      id: @message.id,
      body: @message.body,
      created_at: @message.created_at,
      updated_at: @message.updated_at,
      author: {
        id: @message.author.id,
        name: @message.author.name
      }
    }
  end

  def to_api_resource_hash
    { answer: to_api_collection_hash.merge(collections) }
  end

  def attachments
    @message.attachments.map { |attachment| attachment.file.url }
  end

  def comments
    @message.comments.map do |comment|
      {
        id: comment.id,
        body: comment.body,
        created_at: comment.created_at,
        updated_at: comment.updated_at,
        author: {
          id: comment.author.id,
          name: comment.author.name
        }
      }
    end
  end
end
