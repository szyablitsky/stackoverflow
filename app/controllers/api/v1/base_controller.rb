class Api::V1::BaseController < InheritedResources::Base
  doorkeeper_for :all
  layout false

  protected

  def current_resource_owner
    if doorkeeper_token
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
