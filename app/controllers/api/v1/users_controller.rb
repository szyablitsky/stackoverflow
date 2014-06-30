class Api::V1::UsersController < Api::V1::BaseController
  respond_to :json

  def me
    respond_with({ user: current_resource_owner })
  end

  def index
    respond_with({ users: User.all })
  end
end
