# frozen_string_literal: true

module Normalizy
  module Filters
    module BlacklistBlock
      def self.call(input)
        yield input
      end
    end
  end
end
