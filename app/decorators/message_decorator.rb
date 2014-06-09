class MessageDecorator < Draper::Decorator
  delegate_all
  delegate :url_helpers, to: 'Rails.application.routes'

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

  def link_to_edit
    path = answer? ?
           url_helpers.edit_question_answer_path(topic,object) :
           url_helpers.edit_question_path(topic)
    %Q(<a href="#{path}">edit</a>).html_safe
  end

  def add_comment_class
    disabled = h.current_user.reputation < Privilege.create_comment ?
               ' disabled' :
               ''
    "add-comment#{disabled}"
  end
end
