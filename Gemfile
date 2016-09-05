source 'https://rubygems.org'

ruby_version_file = Pathname.new(__FILE__) + '../.ruby-version'
ruby IO.read(ruby_version_file).strip

gem 'business_time'
gem 'devise', '~> 3.5.1'
gem 'draper', '~> 2.1.0'
gem 'enumerate_it'
gem 'iugu', '~> 1.0.8'
gem 'pg'
gem 'pundit', '~> 1.0.0'
gem 'rails', '4.2.4'
gem 'split', '~> 2.1.0', require: 'split/dashboard'

# Client side
gem 'accountingjs-rails'
gem 'asset_sync', github: 'rumblelabs/asset_sync'
gem 'autoprefixer-rails'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'coffee-rails', '~> 4.1.0'
gem 'font-awesome-rails'
gem 'initjs', '~> 2.1.2'
gem 'jquery-rails'
gem 'maskedinput-rails'
gem 'metamagic'
gem 'nprogress-rails'
gem 'sass-rails', '~> 5.0'
gem 'simple_form', '~> 3.2.0'
gem 'slim-rails', '~> 3.0.1'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'

# File processing
gem 'carrierwave'
gem 'fog', require: 'fog/aws/storage'
gem 'mini_magick'

# I18n
gem 'devise-i18n'
gem 'rails-i18n', '~> 4.0.4'

# Admin
gem 'active_admin_editor', github: 'boontdustie/active_admin_editor'
gem 'activeadmin', github: 'gregbell/active_admin'

group :production do
  gem 'newrelic_rpm'
  gem 'passenger', '~> 5.0'
  gem 'rails_12factor', '~> 0.0.3'
end

group :development, :test do
  gem 'awesome_print', '~> 1.6.1', require: false
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'machinist', '~> 2.0'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.3.2'
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'spring'
  gem 'thin', '~> 1.6.3'
  gem 'web-console', '~> 2.0'
end

group :development do
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner', '~> 1.5.1'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.0.1'
  gem 'simplecov', '~> 0.10.0', require: false
  gem 'webmock', '~> 1.22.1'
end
