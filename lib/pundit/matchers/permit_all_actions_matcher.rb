# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    class PermitAllActionsMatcher < BaseMatcher
      NOT_SUPPORTED_ERROR = '`expect().not_to permit_all_actions` is not supported.'

      def description
        'permit all actions'
      end

      def matches?(policy)
        setup_policy_info! policy

        policy_info.forbidden_actions.empty?
      end

      def does_not_match?(_policy)
        raise NotImplementedError, NOT_SUPPORTED_ERROR
      end

      def failure_message
        message = +"expected '#{policy_info}' to permit all actions,"
        message << " but forbade #{policy_info.forbidden_actions}"
        message << user_message
      end
    end
  end
end
