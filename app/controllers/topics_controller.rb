class TopicsController < InheritedResources::Base
  before_action :authenticate_user!, except: [:home, :index, :show]
  actions :all, except: :destroy
  custom_actions resource: [:subscribe, :unsubscribe]
  respond_to :js, only: [:subscribe, :unsubscribe]

  load_and_authorize_resource
  skip_load_resource only: [:home, :index, :show]
  skip_authorize_resource only: [:home, :index, :show]

  def home
    @topics = Topic.for_home_page.decorate
  end

  def index
    if params[:search]
      @topics = Topic.search(params[:search]).map { |t| t.decorate }
    else
      @topics = Topic.includes(:tags, question: :author).all.decorate
    end
  end

  def show
    include_params = { answers: [:author, :attachments, { comments: :author }] }
    @topic = Topic.includes(:question, include_params).find(params[:id]).decorate
    @topic.increment_views
    @answer = @topic.answers.build
  end

  def new
    build_resource.build_question
  end

  def create
    resource.question.author = current_user
    create! do |success, failure|
      success.html do
        TagService.process params[:topic][:tags], for: resource
        subscribe
        publish_new_topic
        redirect_to question_path(resource)
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        TagService.process params[:topic][:tags], for: resource
        redirect_to question_path(resource)
      end
    end
  end

  def subscribe
    Subscription.create!(topic: resource, user: current_user)
  end

  def unsubscribe
    Subscription.where(topic: resource, user: current_user).destroy_all
  end

  private

  def publish_new_topic
    data = TopicsSerializer.new(resource).to_hash type: :private_pub
    PrivatePub.publish_to '/topics/new', data
  end

  def topic_params
    params.require(:topic).permit(
      :title,
      question_attributes: [:id, :body,
                            attachments_attributes: [:file]]
    )
  end
end
