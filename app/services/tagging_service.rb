class TaggingService
  def self.process(tags_string, options)
    return unless tags_string
    topic = options[:for]
    tags_string.split(',').each do |tag_name|
      topic.tags << Tag.find_or_create_by!(name: tag_name)
    end
  end
end
