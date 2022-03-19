# frozen_string_literal: true

require_relative 'lib/normalizy/version'

Gem::Specification.new do |spec|
  spec.author           = 'Washington Botelho'
  spec.description      = 'Attribute normalizer for Rails.'
  spec.email            = 'wbotelhos@gmail.com'
  spec.extra_rdoc_files = Dir['CHANGELOG.md', 'LICENSE', 'README.md']
  spec.files            = Dir['lib/**/*']
  spec.homepage         = 'https://github.com/wbotelhos/normalizy'
  spec.license          = 'MIT'
  spec.name             = 'normalizy'
  spec.summary          = 'Attribute normalizer for Rails.'
  spec.version          = Normalizy::VERSION

  spec.add_dependency 'activerecord', '>= 4.1'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'sqlite3'
end
