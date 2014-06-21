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

  def link_to(action) # voteup / votedown
    direction = action.to_s[4..-1]
    icon = %Q(<span class="glyphicon glyphicon-circle-arrow-#{direction}"></span>).html_safe

    if h.can?(action, object)
      h.link_to icon, url_helpers.send("#{action}_question_answer_path".to_sym, topic, object),
                method: :post, remote: true, class: "vote-#{direction}",
                title: "vote #{direction}",
                data: { type: :json, toggle: 'tooltip', placement: 'right' }
    else
      h.link_to icon, 'javascript:void(0)', class: "vote-#{direction} disabled",
                title: vote_title(action), data: { toggle: 'tooltip', placement: 'right' }
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
