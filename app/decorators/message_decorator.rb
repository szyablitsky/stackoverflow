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
    h.link_to 'edit', path
  end

  def add_comment_class
    access_class = h.can?(:create, Comment) ? '' : ' disabled'
    "add-comment#{access_class}"
  end

  def link_to(action) # voteup / votedown
    direction = action.to_s[4..-1]
    css_class = "glyphicon glyphicon-circle-arrow-#{direction}"
    icon = %Q(<span class="#{css_class}"></span>).html_safe

    if h.can?(action, object)
      path = "#{action}_question_answer_path".to_sym
      h.link_to icon, url_helpers.send(path, topic, object), method: :post,
                remote: true, class: "vote-#{direction}",
                title: "vote #{direction}",
                data: { type: :json, toggle: 'tooltip', placement: 'right' }
    else
      h.link_to icon, 'javascript:void(0)', title: vote_title(action),
                class: "vote-#{direction} disabled",
                data: { toggle: 'tooltip', placement: 'right' }
    end
  end

  def link_to_subscribtion
    topic = object.topic
    options = { remote: true, method: :post, class: 'subscription' }
    if h.can?(:subscribe, topic)
      h.link_to 'subscribe',
                url_helpers.subscribe_question_path(topic), options
    else
      h.link_to 'unsubscribe',
                url_helpers.unsubscribe_question_path(topic), options
    end
  end

  def type
    object.answer? ? 'answer' : 'question'
  end

  private

  def vote_title(action)
    if h.user_signed_in?
      if object.author == h.current_user
        "You can not vote for your own #{type}"
      else
        direction = action.to_s[4..-1]
        reputation = Privilege.send action
        object.not_voted_by?(h.current_user) ?
          "You must have #{reputation} reputation to vote #{direction}" :
          "You already voted for this #{type}"
      end
    else
      'You have to sign in or sign up to vote'
    end
  end
end
