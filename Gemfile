# frozen_string_literal: true

source 'https://rubygems.org'

gem 'active_model_serializers'
gem 'dry-monads'
gem 'dry-rails'
gem 'dry-validation'
gem 'puma', '>= 5.0'
gem 'rack-cors'
gem 'rails', '~> 8.0.1'
gem 'solid_cache'
gem 'solid_queue'
gem 'sqlite3', '>= 2.1'
gem 'thruster', require: false
gem 'tzinfo-data', platforms: [:windows, :jruby]

group :development do
  gem 'brakeman', require: false
  gem 'debug', platforms: [:mri, :windows], require: 'debug/prelude'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'rspec-rails'
end
