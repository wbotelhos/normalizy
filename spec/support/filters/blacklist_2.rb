# frozen_string_literal: true

module Normalizy
  module Filters
    module Blacklist2
      def self.call(input, options = {})
        attribute = options[:attribute]

        "#{attribute}: #{options[:object].send(attribute)}"
      end
    end
  end
end
