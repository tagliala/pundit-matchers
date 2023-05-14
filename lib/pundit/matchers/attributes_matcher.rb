# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    class AttributesMatcher < BaseMatcher
      ARGUMENTS_REQUIRED_ERROR = 'At least one attribute must be specified'

      def initialize(*expected_attributes)
        raise ArgumentError, ARGUMENTS_REQUIRED_ERROR if expected_attributes.empty?

        super()
        @expected_attributes =
          if expected_attributes.size == 1 && expected_attributes.first.is_a?(Array)
            transform_attributes(expected_attributes.first)
          else
            transform_attributes(expected_attributes)
          end
        @options = {}
      end

      def for_action(action)
        @options[:action] = action
        self
      end

      private

      attr_reader :expected_attributes, :options

      def permitted_attributes(policy)
        @permitted_attributes ||=
          if options.key?(:action)
            transform_attributes(policy.public_send(:"permitted_attributes_for_#{options[:action]}"))
          else
            transform_attributes(policy.permitted_attributes)
          end
      end

      def action_message
        " when autorising the '#{options[:action]}' action"
      end

      def transform_attributes(attributes, ancestors: [])
        case attributes
        when String, Symbol
          wrap_attribute(attributes, ancestors)
        when Hash
          attributes.map do |ancestor, nested_attributes|
            transform_attributes(nested_attributes, ancestors: ancestors + [ancestor])
          end
        when Array
          attributes.map do |attribute|
            transform_attributes(attribute, ancestors: ancestors)
          end.flatten
        end
      end

      def wrap_attribute(attribute, ancestors)
        return attribute.to_sym if ancestors.empty?

        :"#{ancestors.first}[#{wrap_attribute(attribute, ancestors[1..])}]"
      end
    end
  end
end
