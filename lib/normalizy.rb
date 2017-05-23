# frozen_string_literal: true

module Normalizy
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end
end

require 'active_record'
require 'normalizy/config'
require 'normalizy/extensions'
require 'normalizy/rspec/matcher'

ActiveRecord::Base.include Normalizy::Extension
