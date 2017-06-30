source 'https://rubygems.org'

gemspec

gem 'dry-types', git: 'https://github.com/dry-rb/dry-types', branch: 'master'

gem 'rom', git: 'https://github.com/rom-rb/rom', branch: 'master' do
  gem 'rom-core'
  gem 'rom-mapper'
  gem 'rom-repository', group: :tools
end

group :test do
  gem 'inflecto'
  gem 'codeclimate-test-reporter', require: false, platforms: :mri
  gem 'dry-struct'
  gem 'byebug', platforms: :mri
end

group :tools do
  gem 'rubocop'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end
