class UsersController < InheritedResources::Base
  before_action :authenticate_user!, except: [:show]
  actions :show, :edit, :update

  load_and_authorize_resource

  def show
    @questions = Topic.with_questions_by resource
    @answers = Topic.with_answers_by resource
    @reputation_changes = ReputationChange.received_by resource
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
