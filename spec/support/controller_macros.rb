module ControllerMacros
  def login_user
    login create(:user)
  end

  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end
