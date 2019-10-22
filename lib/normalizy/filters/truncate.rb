# frozen_string_literal: true

module Normalizy
  module Filters
    module Truncate
      module_function

      def call(input, options = {})
        return input unless options[:limit].is_a?(Integer)
        return input unless input.is_a?(String)

        input[0, options[:limit]]
      end
    end
  end
end
