class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @topics = Topic.all.includes(:question, :answers)
  end

  def show
    @topic = Topic.includes(:question, :answers).find(params[:id])
    @answer = @topic.answers.build
  end

  def new
    @form = new_form
  end

  def create
    @form = new_form
    @topic = Topic.new
    if @form.validate(params[:question])
      save_topic
      redirect_to question_path(@topic)
    else
      render :new
    end
  end

  private

  def new_form
    QuestionForm.new(Topic.new(question: Message.new))
  end

  def save_topic
    @form.save do |data, nested|
      @topic.title = data.title
      @topic.build_question(nested[:question].merge(author:current_user))
      @topic.save!
    end
  end
end
