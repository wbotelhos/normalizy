# frozen_string_literal: true

module Normalizy
  module Extension
    extend ActiveSupport::Concern

    included do
      before_validation :apply_normalizy, if: -> {
        self.class.respond_to? :normalizy
      }

      private

      def apply_normalizy
        (self.class.normalizy_rules || {}).each do |attribute, rules|
          rules.each { |rule| normalizy! rule.merge(attribute: attribute) }
        end
      end

      def extract_filter(rule, filters: Normalizy.config.filters)
        if rule.is_a?(Hash)
          result  = filters[rule.keys.first] || rule.keys.first
          options = rule.values.first
        else
          result = filters[rule]
        end

        [result || rule, options || {}]
      end

      def extract_value(value, filter, options, block)
        if filter.respond_to?(:call)
          if filter.method(:call).arity == -2
            filter.call value, options, &block
          else
            filter.call value, &block
          end
        elsif respond_to?(filter)
          send filter, value, options, &block
        elsif value.respond_to?(filter)
          value.send filter, &block
        else
          value
        end
      end

      def normalizy!(attribute:, rules:, options:, block:)
        return if rules.blank? && block.blank?

        aliases = Normalizy.config.normalizy_aliases
        value   = nil

        [rules].flatten.compact.each do |rule|
          result_rules = [aliases.key?(rule) ? aliases[rule] : rule]

          result_rules.flatten.compact.each do |result_rule|
            filter, filter_options = extract_filter(result_rule)

            if filter.respond_to?(:name)
              rule_name = filter.name.tableize.split('/').last.singularize.to_sym
            end

            original = original_value(attribute, rule_name, options)
            value    = extract_value(original, filter, filter_options, block)
          end
        end

        return unless value

        write attribute, value
      end

      def original_value(attribute, rule, options)
        if raw? attribute, rule, options
          send "#{attribute}_before_type_cast"
        else
          send attribute
        end
      end

      def raw?(attribute, rule, options)
        return false unless respond_to?("#{attribute}_before_type_cast")

        options[:raw] || Normalizy.config.normalizy_raws.include?(rule)
      end

      def write(attribute, value)
        write_attribute attribute, value
      rescue ActiveModel::MissingAttributeError
        send "#{attribute}=", value
      end
    end

    module ClassMethods
      attr_accessor :normalizy_rules

      def normalizy(*args, &block)
        options = args.extract_options!
        rules   = options[:with] || Normalizy.config.default_filters

        self.normalizy_rules ||= {}

        args.each do |field|
          normalizy_rules[field] ||= []
          normalizy_rules[field] << { block: block, options: options.except(:with), rules: rules }
        end
      end
    end
  end
end
