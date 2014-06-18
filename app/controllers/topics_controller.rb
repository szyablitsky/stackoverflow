class TopicsController < InheritedResources::Base
  before_action :authenticate_user!, except: [:home, :index, :show]
  actions :all, except: :destroy

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
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                        autolink: true, tables: true)
  end

  def new
    build_resource.build_question
  end

  def create
    @topic = Topic.new(topic_params)
    TagService.process params[:topic][:tags], for: @topic
    @topic.question.author = current_user

    create! do |success, failure|
      success.html do
        channel = '/topics/new'
        data = TopicsSerializer.new(@topic).to_hash
        PrivatePub.publish_to channel, data

        redirect_to question_path(@topic)
      end
    end
  end

  def update
    @topic = Topic.find(params[:id])

    return head :forbidden unless @topic.author == current_user

    update! do |success, failure|
      success.html do
        TagService.process params[:topic][:tags], for: @topic
        redirect_to question_path(@topic)
      end
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
