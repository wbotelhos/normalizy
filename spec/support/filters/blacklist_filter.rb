# frozen_string_literal: true

module Normalizy
  module Filters
    module Blacklist
      def self.call(input)
        value = input.gsub('Fuck', 'filtered')

        value = yield(value) if block_given?

        value
      end
    end
  end
end
