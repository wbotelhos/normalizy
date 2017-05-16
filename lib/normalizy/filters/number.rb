# frozen_string_literal: true

module Normalizy
  module Filters
    module Number
      def self.call(input)
        return input unless input.is_a?(String)

        value = input.gsub(/\D/, '')

        return nil if value.blank?

        value.to_i
      end
    end
  end
end
