class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def home
    @topics = Topic.for_home_page.decorate
  end

  def index
    @topics = Topic.includes(:tags, question: :author).all.decorate
  end

  def show
    include_params = { answers: [:author, :attachments, { comments: :author }] }
    @topic = Topic.includes(:question, include_params).find(params[:id]).decorate
    @topic.increment_views
    @answer = @topic.answers.build
  end

  def new
    @topic = Topic.new
    @topic.build_question
  end

  def create
    @topic = Topic.new(topic_params)
    TaggingService.process params[:topic][:tags], for: @topic
    @topic.question.author = current_user
    if @topic.save
      channel = '/topics/new'
      data = TopicsService.new(@topic).to_hash
      PrivatePub.publish_to channel, data
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
