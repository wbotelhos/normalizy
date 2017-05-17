# frozen_string_literal: true

module Normalizy
  module Filters
    module Number
      def self.call(input, options = {})
        return input unless input.is_a?(String)

        value = input.gsub(/\D/, '')

        return nil                        if value.blank?
        return value.send(options[:cast]) if options[:cast]

        value
      end
    end
  end
end
