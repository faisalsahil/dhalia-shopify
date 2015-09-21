source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.14'

# gem 'scaffoldhub'
gem 'gibbon',"~> 1.0.4"
gem 'stripe'
gem 'heroku'

group :production do
   gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
  gem  'mysql2'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
  gem 'execjs'
end

gem 'jquery-rails', '~> 2.2.1'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'cancan'
gem 'devise'
gem 'simple_form'
gem 'twitter-bootstrap-rails'
gem 'shopify_app'
gem 'omniauth'
gem "oauth2", "~> 0.8.0"
gem "httparty"

group :development do
  gem 'better_errors'
  gem 'quiet_assets'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end


group :development, :test do
  gem "less-rails-bootstrap"
  gem "therubyracer", :platforms => :ruby
end
