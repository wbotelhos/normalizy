# frozen_string_literal: true

module Normalizy
  module Filters
    module Truncate
      module_function

      def call(input, options = {})
        return input unless input.is_a?(String) && options[:limit].is_a?(Integer)

        input[0, options[:limit]]
      end
    end
  end
end
