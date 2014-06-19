class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  # def setup_markdown
  #   @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
  #                                       autolink: true, tables: true)
  # end
end
