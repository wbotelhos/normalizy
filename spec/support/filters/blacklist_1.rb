# frozen_string_literal: true

module Normalizy
  module Filters
    module Blacklist1
      def self.call(input)
        input.gsub 'Fuck', 'filtered'
      end
    end
  end
end
