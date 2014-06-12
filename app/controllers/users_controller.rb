class UsersController < InheritedResources::Base
  before_action :authenticate_user!, except: [:show]
  actions :show, :edit, :update

  def show
    @user = User.find(params[:id])
    @questions = Topic.with_questions_by @user
    @answers = Topic.with_answers_by @user
  end

  def update
    return head :forbidden unless current_user.id.to_s == params[:id]
    update!
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
