source 'https://rubygems.org'
# Newest version is 2.1.3, but that is not yet supported by
# Travis when deploying to Heroku
# see: https://github.com/heroku/heroku-buildpack-ruby/issues/304 and
# https://github.com/heroku/heroku-buildpack-ruby/issues/308
ruby "2.1.2"

#
# When adding gems, make sure they are Rails 4 and Ruby 2.1.2 compatible
#

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: :development

# use postgresql in production (for deployment on heroku)
gem 'pg', group: :production

# Use Bootstrap, see app/assets/stylesheets
gem 'twitter-bootstrap-rails'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# authentification, see: https://github.com/plataformatec/devise
gem 'devise'
gem 'devise_openid_authenticatable' # https://github.com/nbudin/devise_openid_authenticatable
gem 'rack-openid' # https://github.com/josh/rack-openid

# testing framework, see: https://github.com/rspec/rspec-rails
gem 'rspec-rails'

# fixtures replacement, see: https://github.com/thoughtbot/factory_girl_rails
gem 'factory_girl_rails', :require => false

# better error pages, see: https://github.com/charliesome/better_errors
gem 'better_errors', group: :development
gem 'binding_of_caller', group: :development

# an IRB alternative and runtime developer console
gem 'pry', group: :development
gem 'pry-rails', group: :development

# code coverage analysis tool, see: https://github.com/colszowka/simplecov
gem 'simplecov', require: false, group: :test

# continuation of CanCan, the authorization Gem for Ruby on Rails,
# see: https://github.com/CanCanCommunity/cancancan
gem 'cancancan', '~> 1.9'

# collects test coverage data from your Ruby test suite
# and sends it to Code Climate's hosted, automated code review service,
# see: https://github.com/codeclimate/ruby-test-reporter
gem "codeclimate-test-reporter", group: :test, require: nil

# performance management system, see: https://github.com/newrelic/rpm
gem 'newrelic_rpm'

# Needed for Heroku deployment
gem 'rails_12factor', group: :production

# Send application errors to hosted service instead of email inbox.
gem 'airbrake'

# Library for data binding HTML Elements to Javascript Objects
gem 'knockoutjs-rails'

gem 'mocha'

gem 'fullcalendar-rails', '~> 2.0.2.0'
gem 'momentjs-rails'
gem 'filterrific'

gem 'will_paginate'
gem 'will_paginate-bootstrap'

gem 'date_time_attribute'

gem 'ranked-model'
gem 'bootstrap3-datetimepicker-rails', '~> 3.1.3'

gem 'jquery-turbolinks'

# creating navigations (with multiple levels)
# see: https://github.com/codeplant/simple-navigation
# gem simple-navigation

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :test, :development  do 
	gem 'capybara'
	gem 'guard-rspec'
	gem 'database_cleaner'
	gem 'rack_session_access'
	gem 'rails-dev-tweaks'
	gem 'timecop'
end

