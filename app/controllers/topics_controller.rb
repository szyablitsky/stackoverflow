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
    @topic = Topic.new
    @topic.build_question
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.question.author = current_user
    if @topic.save
      redirect_to question_path(@topic)
    else
      render :new
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, question_attributes: [:body])
  end
end
