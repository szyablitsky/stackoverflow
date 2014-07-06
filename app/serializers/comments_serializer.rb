class CommentsSerializer
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(comment)
    @comment = comment
  end

  def to_hash(options)
    self.send "to_#{options[:type]}_hash".to_sym
  end

  private

  def to_private_pub_hash
    {
      message_id: @comment.message.id,
      id: @comment.id,
      body: @comment.body,
      author: {
        name: @comment.author.name,
        url: url_helpers.user_path(@comment.author)
      },
      time: {
        iso: @comment.created_at.to_formatted_s(:iso8601),
        human: @comment.created_at.to_formatted_s(:long)
      }
    }
  end
end
