# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'support/coverage'

require 'normalizy'
require 'pry-byebug'

require 'support/db/schema'
require 'support/filters/blacklist'
require 'support/filters/block'
require 'support/filters/info'
require 'support/models'
