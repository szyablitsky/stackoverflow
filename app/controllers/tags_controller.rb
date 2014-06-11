class TagsController < InheritedResources::Base
  respond_to :json, only: :index
end
