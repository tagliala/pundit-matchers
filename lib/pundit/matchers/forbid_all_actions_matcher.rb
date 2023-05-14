# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    class ForbidAllActionsMatcher < BaseMatcher
      NOT_SUPPORTED_ERROR = '`expect().not_to forbid_all_actions` is not supported.'

      def description
        'forbid all actions'
      end

      def matches?(policy)
        setup_policy_info! policy

        policy_info.permitted_actions.empty?
      end

      def does_not_match?(_policy)
        raise NotImplementedError, NOT_SUPPORTED_ERROR
      end

      def failure_message
        message = +"expected '#{policy_info}' to forbid all actions,"
        message << " but permitted #{policy_info.permitted_actions}"
        message << user_message
      end
    end
  end
end
