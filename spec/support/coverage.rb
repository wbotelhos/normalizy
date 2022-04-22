# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'codecov'

  SimpleCov.formatter = SimpleCov::Formatter::Codecov

  SimpleCov.minimum_coverage(ENV.fetch('MINIMUM_COVERAGE', 80).to_i)

  SimpleCov.start('rails') do
    add_filter [
      '/lib/generators',
      '/lib/normalizy/version.rb',
      '/vendor',
    ]
  end
end
