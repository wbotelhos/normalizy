# frozen_string_literal: true

module Normalizy
  module RSpec
    def normalizy(attribute)
      Matcher.new attribute
    end

    class Matcher
      def initialize(attribute)
        @attribute = attribute
      end

      def description
        return "normalizy #{@attribute} with #{with_expected}" if @with.present?

        "normalizy #{@attribute} from #{from_value} to #{to_value}"
      end

      def failure_message
        return "expected: #{with_expected}\n     got: #{actual_value}" if @with.present?

        "expected: #{to_value}\n     got: #{actual_value}"
      end

      def failure_message_when_negated
        return "expected: value != #{with_expected}\n     got: #{actual_value}" if @with.present?

        "expected: value != #{to_value}\n     got: #{actual_value}"
      end

      def from(value)
        @from = value

        self
      end

      def matches?(subject)
        @subject = subject

        if @with.present?
          options = @subject.class.normalizy_rules[@attribute]

          return false if options.blank?

          options = default_rules if options.map { |option| option[:rules] }.compact.blank?

          return false if options.blank?

          options.each do |option|
            rules = option[:rules]

            return true if rules.is_a?(Array) && rules.include?(@with)
            return true if rules == @with
          end

          false
        else
          @subject.send :"#{@attribute}=", @from

          @subject[@attribute] == @to
        end
      end

      def to(value)
        @to = value

        self
      end

      def with(value)
        @with = value

        self
      end

      private

      def actual_value
        return with_value if @with

        value = @subject.send(@attribute)

        value.is_a?(String) ? %("#{value}") : value
      end

      def default_rules
        [Normalizy.config.default_filters].flatten.compact.map do |rule|
          { rules: rule }
        end
      end

      def from_value
        @from.nil? ? :nil : %("#{@from}")
      end

      def to_value
        @to.nil? ? :nil : %("#{@to}")
      end

      def with_expected
        @with
      end

      def with_value
        options = @subject.class.normalizy_rules[@attribute]

        return :nil            if options.nil?
        return %("#{options}") if options.blank?

        result = options.map do |option|
          rules = option[:rules]

          return :nil if rules.nil?

          rules.presence || %("#{rules}")
        end

        result.join ', '
      end
    end
  end
end
