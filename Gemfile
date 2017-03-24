source 'https://rubygems.org'

gemspec

gem 'rom', git: 'https://github.com/rom-rb/rom.git', branch: 'master'
gem 'rom-repository', git: 'https://github.com/rom-rb/rom-repository.git', branch: 'master'

group :test do
  gem 'inflecto'
  gem 'codeclimate-test-reporter', require: false, platforms: :mri
  gem 'virtus'
  gem 'byebug', platforms: :mri
end

group :tools do
  gem 'rubocop'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end
