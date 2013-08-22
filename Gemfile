source 'https://rubygems.org'

# Provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-0-stable'

gemspec

gem 'simple_form'

group :test do
  # Specifying JavaScript Runtime for the test application
  # TODO shouldn't Rails use convention by default for this?
  gem 'therubyracer', :platforms => :ruby
  gem "launchy"
end

group :test, :development do
  gem "debugger"
end