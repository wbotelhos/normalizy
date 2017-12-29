# frozen_string_literal: true

require 'normalizy/filters'

module Normalizy
  class Config
    attr_accessor :default_filters
    attr_reader :filters, :normalizy_aliases

    def add(name, value)
      @filters[name] = value

      self
    end

    def alias(name, to)
      @normalizy_aliases[name] = to

      self
    end

    def initialize
      @default_filters   = {}
      @normalizy_aliases = {}

      @filters = {
        date:    Normalizy::Filters::Date,
        money:   Normalizy::Filters::Money,
        number:  Normalizy::Filters::Number,
        percent: Normalizy::Filters::Percent,
        slug:    Normalizy::Filters::Slug,
        strip:   Normalizy::Filters::Strip
      }
    end
  end
end
