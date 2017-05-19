# frozen_string_literal: true

module Normalizy
  module Filters
    module Percent
      class << self
        def call(input, options = {})
          return input unless input.is_a?(String)

          value = input.gsub(/[^[0-9]#{separator(options)}]/, '')

          return nil if value.blank?

          value = "%0.#{precision(options)}f" % [value.sub(separator(options), '.')]
          value = value.delete('.') if cents?(options)

          return value.send(options[:cast]) if options[:cast]

          value
        end

        private

        def cents?(options)
          options[:type]&.to_sym == :cents
        end

        def precision(options)
          options.fetch :precision, I18n.t('percentage.format.precision', default: 2)
        end

        def separator(options)
          options.fetch :separator, I18n.t('percentage.format.separator', default: '.')
        end
      end
    end
  end
end
