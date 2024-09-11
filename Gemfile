source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# default gems
gem "rails", "~> 7.0.6"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

# Ensure ruby style guide
group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end