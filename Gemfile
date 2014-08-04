source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'private_pub'
gem 'thin'
gem 'pg'

gem 'slim-rails'
gem 'redcarpet'
gem 'jbuilder'
gem 'oj'
gem 'oj_mimic_json'

gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass'
gem 'uglifier'
gem 'coffee-rails'
gem 'handlebars_assets'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'remotipart'
gem 'rails-timeago'
gem 'select2-rails'

gem 'devise'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'hashie_rails' # ActiveModel::ForbiddenAttributesError workaround for OmniAuth::AuthHash
gem 'cancancan'
gem 'draper'
gem 'carrierwave'
gem 'inherited_resources'
gem 'doorkeeper'
gem 'redis-throttle', github: 'andreareginato/redis-throttle'
gem 'sidekiq'
# gem 'sidetiq' # travis-ci incompatibility
gem 'sinatra', require: false
gem 'mysql2'
gem 'thinking-sphinx'

gem 'bootstrap_form'
gem 'nested_form'
gem 'nav_lynx'
gem 'gravatar_image_tag'

gem 'rails_12factor', group: :production

group :development do
  gem 'brakeman'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'rb-readline'
  gem 'forgery'
  gem 'bullet'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'launchy'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'poltergeist'
  gem 'json_spec'
  gem 'timecop'
end
