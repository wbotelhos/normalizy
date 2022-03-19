# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'support/coverage'

require 'normalizy'
require 'pry-byebug'

require 'support/db/schema'
require 'support/filters/blacklist'
require 'support/filters/block'
require 'support/filters/info'

require 'support/models/alias'
require 'support/models/match'
require 'support/models/model'
require 'support/models/model_date'
require 'support/models/model_money'
require 'support/models/model_number'
require 'support/models/model_percent'
require 'support/models/model_slug'
require 'support/models/model_strip'
require 'support/models/rule'
