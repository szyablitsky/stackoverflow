class Api::V1::UsersController < Api::V1::BaseController
  respond_to :json

  def index
    respond_with({ users: collection })
  end

  def me
    respond_with({ user: current_resource_owner })
  end
end
