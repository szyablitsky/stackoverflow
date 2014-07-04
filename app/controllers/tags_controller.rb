class TagsController < InheritedResources::Base
  respond_to :json, :html, only: :index
end
