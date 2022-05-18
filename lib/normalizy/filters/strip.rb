# frozen_string_literal: true

module Normalizy
  module Filters
    module Strip
      def self.call(input, options = {})
        return input unless input.is_a?(String)

        regex = {
          both:  '\A\s*|\s*\z',
          left:  '\A\s*',
          right: '\s*\z',
        }[options[:side] || :both]

        input.gsub Regexp.new(/#{regex}/), ''
      end
    end
  end
end
