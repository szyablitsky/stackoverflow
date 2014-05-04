class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.includes(:question, :answers).find(params[:id])
  end
end