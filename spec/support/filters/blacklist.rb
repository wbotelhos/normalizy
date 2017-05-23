# frozen_string_literal: true

module Normalizy
  module Filters
    module Blacklist
      def self.call(input)
        input.gsub 'Fuck', 'filtered'
      end
    end
  end
end
