# frozen_string_literal: true

module Normalizy
  module Filters
    module BlacklistBlock
      def self.call(input, options = {})
        yield input
      end
    end
  end
end
