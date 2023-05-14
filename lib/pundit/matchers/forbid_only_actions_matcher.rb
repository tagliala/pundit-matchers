# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class ForbidOnlyActionsMatcher < ActionsMatcher
      NOT_SUPPORTED_ERROR = '`expect().not_to forbid_only_actions` is not supported.'

      def description
        "forbid only #{expected_actions}"
      end

      def matches?(policy)
        setup_policy_info! policy
        check_actions!

        @actual_actions = policy_info.forbidden_actions - expected_actions
        @extra_actions = policy_info.permitted_actions & expected_actions

        actual_actions.empty? && extra_actions.empty?
      end

      def does_not_match?(_policy)
        raise NotImplementedError, NOT_SUPPORTED_ERROR
      end

      def failure_message
        message = +"expected '#{policy_info}' to forbid only #{expected_actions},"
        message << " but forbade #{actual_actions}" unless actual_actions.empty?
        message << extra_message unless extra_actions.empty?
        message << user_message
      end

      private

      attr_reader :actual_actions, :extra_actions

      def extra_message
        message =
          if actual_actions.empty?
            +' but'
          else
            +' and'
          end

        message << " permitted #{extra_actions}"
      end
    end
  end
end
