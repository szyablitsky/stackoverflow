class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
  end
end