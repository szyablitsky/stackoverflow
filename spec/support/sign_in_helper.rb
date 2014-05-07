module Features
  def user_signed_in
    user = create(:user)
    login_as(user, scope: :user)
  end
end
