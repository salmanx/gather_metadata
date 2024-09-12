# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# default gems
gem 'bootsnap', require: false
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.6'
gem 'sqlite3', '~> 1.4'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Service object
gem 'subroutine', '~> 1.0', '>= 1.0.1'
# Web scrapper
gem 'puppeteer-ruby'
# JSON serializer
gem 'blueprinter'
# Run background job using active job
gem 'sidekiq'

# Ensure ruby style guide
group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

# Test
group :test do
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
end
