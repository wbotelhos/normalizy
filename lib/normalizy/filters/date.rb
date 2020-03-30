# frozen_string_literal: true

module Normalizy
  module Filters
    module Date
      class << self
        def call(input, options = {})
          if input.is_a?(String)
            return input if input.blank?

            Time.use_zone(time_zone(options)) do
              input = Time.zone.strptime(input, format(options))
            end
          end

          input = input.beginning_of_day if options[:adjust] == :begin && input.respond_to?(:beginning_of_day)
          input = input.end_of_day       if options[:adjust] == :end   && input.respond_to?(:end_of_day)

          input
        rescue ArgumentError
          options[:object].errors.add options[:attribute], error_message(input, options)
        end

        private

        def error_message(input, options)
          I18n.t options[:attribute], scope: [
            'normalizy.errors.date', options[:object].class.name.underscore
          ], value: input, default: '%{value} is an invalid date.'
        end

        def format(options)
          options.fetch :format, '%F'
        end

        def time_zone(options)
          options.fetch :time_zone, 'UTC'
        end
      end
    end
  end
end
