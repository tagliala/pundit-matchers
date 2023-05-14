# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class PermitActionsMatcher < ActionsMatcher
      def description
        "permit #{expected_actions}"
      end

      def matches?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = expected_actions.reject do |action|
          policy.public_send(:"#{action}?")
        end

        actual_actions.empty?
      end

      def does_not_match?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = expected_actions.select do |action|
          policy.public_send(:"#{action}?")
        end

        actual_actions.empty?
      end

      def failure_message
        message = +"expected '#{policy_info}' to permit #{expected_actions},"
        message << " but forbade #{actual_actions}"
        message << user_message
      end

      def failure_message_when_negated
        message = +"expected '#{policy_info}' to forbid #{expected_actions},"
        message << " but permitted #{actual_actions}"
        message << user_message
      end

      private

      attr_reader :actual_actions
    end
  end
end
