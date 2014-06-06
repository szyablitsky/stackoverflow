class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:home, :index, :show]

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
      data = TopicsSerializer.new(@topic).to_hash
      PrivatePub.publish_to channel, data

      redirect_to question_path(@topic)
    else
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])

    return head :forbidden unless @topic.author == current_user

    if @topic.update(topic_params)
      TaggingService.process params[:topic][:tags], for: @topic
      redirect_to question_path(@topic)
    else
      render :edit
    end
  end

  private

  def topic_params
    params.require(:topic).permit(
      :title,
      question_attributes: [:id, :body,
                            attachments_attributes: [:file]]
    )
  end
end
