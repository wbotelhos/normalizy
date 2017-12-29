# frozen_string_literal: true

module Normalizy
  module Filters
    module Slug
      class << self
        def call(input, options = {})
          return input unless input.is_a?(String)

          input.parameterize
        end
      end
    end
  end
end
