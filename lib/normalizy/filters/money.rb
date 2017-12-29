# frozen_string_literal: true

module Normalizy
  module Filters
    module Money
      class << self
        def call(input, options = {})
          return input unless input.is_a?(String)

          value = input.gsub(/[^[0-9]#{separator(options)}]/, '')

          return nil if value.blank?

          if cents?(options)
            value = precisioned(value, options).delete('.') if value.include? separator(options)
          else
            value = precisioned(value, options)
          end

          return value.send(options[:cast]) if options[:cast]

          value
        end

        private

        def cents?(options)
          options[:type]&.to_sym == :cents
        end

        def precision(options)
          options.fetch :precision, I18n.t('currency.format.precision', default: 2)
        end

        def precisioned(value, options)
          format("%0.#{precision(options)}f", value.sub(separator(options), '.'))
        end

        def separator(options)
          options.fetch :separator, I18n.t('currency.format.separator', default: '.')
        end
      end
    end
  end
end
