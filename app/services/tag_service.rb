class TagService
  def self.process(tags_string, options)
    return unless tags_string

    topic = options[:for]

    old_tags = topic.tags.map(&:name)
    new_tags = tags_string.split(',')

    (old_tags - new_tags).each do |tag_name|
      topic.tags.destroy(Tag.find_by(name: tag_name))
    end

    (new_tags - old_tags).each do |tag_name|
      topic.tags << Tag.find_or_create_by!(name: tag_name)
    end
  end
end
