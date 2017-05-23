# frozen_string_literal: true

module Normalizy
  module Filters
    module Info
      def self.call(input, options = {})
        [options[:attribute], input, options[:object].class].join ', '
      end
    end
  end
end
