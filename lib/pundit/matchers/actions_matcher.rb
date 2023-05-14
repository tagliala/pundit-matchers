# frozen_string_literal: true

require_relative 'base_matcher'

module Pundit
  module Matchers
    class ActionsMatcher < BaseMatcher
      ACTIONS_NOT_IMPLEMENTED_ERROR = "'%<policy>s' does not implement %<actions>s"
      ARGUMENTS_REQUIRED_ERROR = 'At least one action must be specified'

      def initialize(*expected_actions)
        raise ArgumentError, ARGUMENTS_REQUIRED_ERROR if expected_actions.empty?

        super()
        @expected_actions = expected_actions.flatten.sort
      end

      private

      attr_reader :expected_actions

      def check_actions!
        missing_actions = expected_actions - policy_info.actions
        return if missing_actions.empty?

        raise ArgumentError, format(
          ACTIONS_NOT_IMPLEMENTED_ERROR,
          policy: policy_info, actions: missing_actions
        )
      end
    end
  end
end
