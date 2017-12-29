# frozen_string_literal: true

module Normalizy
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      def extract_filter(rule, rule_options, attribute, filters: Normalizy.config.filters)
        options = rule_options.merge(attribute: attribute, object: self)

        return [filters[rule] || rule, options] unless rule.is_a?(Hash)

        filter  = filters[rule.keys.first] || rule
        options = (rule.values.first || {}).merge(options)

        [filter, options]
      end

      def extract_rule(rule)
        if rule.is_a?(Hash)
          [rule.keys.first, rule.values.first]
        else
          [rule, {}]
        end
      end

      def extract_value(value, filter, options, block)
        if filter.respond_to?(:call)
          if filter.method(:call).arity == -2
            filter.call value, options, &block
          else
            filter.call value, &block
          end
        elsif respond_to?(filter)
          if method(filter).arity == -2
            send filter, value, options, &block
          else
            send filter, value, &block
          end
        elsif value.respond_to?(filter)
          value.send filter, &block
        else
          value
        end
      end

      def normalizy!(attribute:, block:, options:, rules:, value:)
        rules ||= Normalizy.config.default_filters

        return if rules.blank? && block.blank?

        result = value

        [rules].flatten.compact.each do |rule|
          rule_name, rule_options = extract_rule(rule)

          unalias_for(rule_name).each do |unaliased_rule|
            filter, filter_options = extract_filter(unaliased_rule, rule_options, attribute)
            result                 = extract_value(result, filter, filter_options, block)
          end
        end

        result
      end

      def unalias_for(rule, aliases: Normalizy.config.normalizy_aliases)
        [aliases.key?(rule) ? aliases[rule] : rule].flatten.compact
      end
    end

    module ClassMethods
      attr_accessor :normalizy_rules

      def normalizy(*args, &block)
        options = args.extract_options!
        rules   = options[:with]

        self.normalizy_rules ||= {}

        args.each do |field|
          normalizy_rules[field] ||= []
          normalizy_rules[field] << { block: block, options: options.except(:with), rules: rules }
        end

        prepend Module.new {
          args.each do |attribute|
            define_method :"#{attribute}=" do |value|
              result = normalizy!(
                attribute: attribute,
                block:     block,
                options:   options.except(:with),
                rules:     rules,
                value:     value
              )

              if rules.is_a?(Hash) && rules.dig(:slug, :to).present?
                write_attribute rules.dig(:slug, :to), result
              else
                super result
              end
            end
          end
        }
      end
    end
  end
end
