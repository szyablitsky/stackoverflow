class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.includes(:question, :answers).find(params[:id])
  end

  def new
    @form = new_form
  end

  def create
    @form = new_form
    if @form.validate(params[:question])
      save_topic do |topic|
        redirect_to question_path(topic)
      end
    else
      render :new
    end
  end

  private

  def new_form
    QuestionForm.new(Topic.new(question: Message.new))
  end

  def save_topic
    topic = Topic.new
    @form.save do |data, nested|
      topic.title = data.title
      topic.build_question(nested[:question])
      topic.save!
      yield topic if block_given?
    end
  end
end
