# frozen_string_literal: true

require_relative 'attributes_matcher'

module Pundit
  module Matchers
    class PermitAttributesMatcher < AttributesMatcher
      def description
        "permit the mass assignment of #{expected_attributes}"
      end

      def matches?(policy)
        setup_policy_info! policy

        @actual_attributes = expected_attributes - permitted_attributes(policy)

        actual_attributes.empty?
      end

      def does_not_match?(policy)
        setup_policy_info! policy

        @actual_attributes = expected_attributes & permitted_attributes(policy)

        actual_attributes.empty?
      end

      def failure_message
        message = +"expected '#{policy_info}' to permit the mass assignment of #{expected_attributes}"
        message << action_message if options.key?(:action)
        message << ", but forbade the mass assignment of #{actual_attributes}"
        message << user_message
      end

      def failure_message_when_negated
        message = +"expected '#{policy_info}' to forbid the mass assignment of #{expected_attributes}"
        message << action_message if options.key?(:action)
        message << ", but permitted the mass assignment of #{actual_attributes}"
        message << user_message
      end

      private

      attr_reader :actual_attributes
    end
  end
end
