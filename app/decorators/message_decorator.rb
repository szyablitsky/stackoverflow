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

  def link_to_edit
    path = answer? ?
           url_helpers.edit_question_answer_path(topic, object) :
           url_helpers.edit_question_path(topic)
    %Q(<a href="#{path}">edit</a>).html_safe
  end

  def add_comment_class
    access_class = h.can?(:create, Comment) ? '' : ' disabled'
    "add-comment#{access_class}"
  end
end
