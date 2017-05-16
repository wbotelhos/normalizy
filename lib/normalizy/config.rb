# frozen_string_literal: true

require 'normalizy/filters'

module Normalizy
  class Config
    attr_accessor :default_filters
    attr_reader :filters, :normalizy_aliases, :normalizy_raws

    def add(name, value, raw: false)
      @filters[name] = value
      @normalizy_raws << name if raw

      self
    end

    def alias(name, to, raw: false)
      @normalizy_aliases[name] = to
      @normalizy_raws << name if raw

      self
    end

    def initialize
      @default_filters   = {}
      @normalizy_aliases = {}
      @normalizy_raws    = [:number]

      @filters = {
        number: Normalizy::Filters::Number,
        strip:  Normalizy::Filters::Strip
      }
    end
  end
end
