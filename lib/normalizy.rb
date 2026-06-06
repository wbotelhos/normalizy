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

ActiveSupport.on_load(:active_record) { include Normalizy::Extension }
