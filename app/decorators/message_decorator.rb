class MessageDecorator < Draper::Decorator
  delegate_all

  def attachments_list
    attachments_array = attachments.to_a
    attachments_array.map! do |attachment|
      h.link_to attachment.file.file.identifier, attachment.file.url
    end
    attachments_array.join(', ').html_safe
  end

  def tags_list
    tags_array = topic.tags.to_a
    tags_array.map! do |tag|
      "<span class=\"label label-info\">#{tag.name}</span>"
    end
    tags_array.join(' ').html_safe
  end

  def add_comment_class
    disabled = h.current_user.reputation < Privilege.create_comment ?
               ' disabled' :
               ''
    "add-comment#{disabled}"
  end
end
