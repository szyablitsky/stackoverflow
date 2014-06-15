class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook; auth; end
  def github; auth; end

  private

  def auth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      provider = request.env['omniauth.auth'].provider.titleize
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session['devise.omniauth_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
