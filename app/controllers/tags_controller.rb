class TagsController < InheritedResources::Base
  respond_to :json, only: :index

  # def index
  #   @tags = Tag.all
  # end
end
