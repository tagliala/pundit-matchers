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
            expected_attributes.first
          else
            expected_attributes
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
            policy.public_send(:"permitted_attributes_for_#{options[:action]}")
          else
            policy.permitted_attributes
          end
      end

      def action_message
        " when autorising the '#{options[:action]}' action"
      end
    end
  end
end
