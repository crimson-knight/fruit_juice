# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in fruit_juice.gemspec
gemspec

gem "rake", "~> 13.0"

if RUBY_VERSION >= "2.4.0"
  gem "byebug", "~> 11.0"
end

if RUBY_VERSION <= "2.4.0"
  gem "connection_pool", "2.2.5"
end

group :test do 
  gem "rspec", "~> 3.0"
end
