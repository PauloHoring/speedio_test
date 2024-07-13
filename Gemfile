# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'activejob', '~> 5.2.8.1'
gem 'dotenv-rails'
gem 'globalid'
gem 'httparty'
gem 'jwt'
gem 'mongoid', '~> 7.0.5'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.8', '>= 5.2.8.1'
gem 'rspec-rails'
gem 'sidekiq'
gem 'whenever'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
