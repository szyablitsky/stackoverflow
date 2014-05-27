class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @topics = Topic.all.includes(:question, :answers).decorate
  end

  def show
    @topic = Topic.includes(:question, :answers).find(params[:id]).decorate
    @topic.increment_views
    @answer = @topic.answers.build
  end

  def new
    @topic = Topic.new
    @topic.build_question
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.process_tags(params[:topic][:tags])
    @topic.question.author = current_user
    if @topic.save
      redirect_to question_path(@topic)
    else
      render :new
    end
  end

  private

  def topic_params
    params.require(:topic).permit(
      :title,
      question_attributes: [:body,
                            attachments_attributes: [:file]]
    )
  end
end
