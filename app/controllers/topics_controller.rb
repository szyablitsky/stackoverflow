class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.includes(:question, :answers).find(params[:id])
  end

  def new
    @form = question_form
  end

  def create
    @form = question_form
    if @form.validate(params[:question])
      save_topic do |topic|
        redirect_to question_path(topic)
      end
    else
      render :new
    end
  end

  private

  def question_form
    QuestionForm.new(Topic.new(question: Message.new))
  end

  def save_topic
    topic = Topic.new
    # topic = nil
    @form.save do |data, nested|
      topic.title = data.title
      topic.build_question(nested[:question])
      # topic = Topic.new(nested)
      topic.save!
      yield topic if block_given?
    end
    # topic
  end
end
