# frozen_string_literal: true

require_relative 'utils/policy_info'

module Pundit
  module Matchers
    class ActionsMatcher
      ARGUMENTS_REQUIRED_ERROR = 'At least one action must be specified'
      POLICY_DOES_NOT_IMPLEMENT_ERROR = 'Policy does not implement %<actions>s'
      NEGATED_MATCHER_ERROR = 'Negated matchers are not supported. Please use `to permit` instead of `not_to forbid`'
      VERBS = {
        permit: {
          expected: 'permit',
          actual: 'forbade',
          actual_when_negated: 'permitted'
        },
        forbid: {
          expected: 'forbid',
          actual: 'permitted',
          actual_when_negated: 'forbade'
        }
      }.freeze

      def initialize(type, *expected_actions)
        raise ArgumentError, ARGUMENTS_REQUIRED_ERROR if expected_actions.count < 1

        @type = type
        @expected_actions = expected_actions.flatten.sort
      end

      def description
        "#{VERBS.dig(type, :expected)} #{expected_actions}"
      end

      def does_not_match?(policy)
        return match?(policy) if type == :permit

        setup_matcher! policy
        check_arguments!

        @actual_actions = expected_actions.select do |action|
          policy.public_send(:"#{action}?")
        end

        actual_actions.empty?
      end

      def matches?(policy)
        return does_not_match?(policy) if type == :forbid

        setup_matcher! policy
        check_arguments!

        @actual_actions = expected_actions.reject do |action|
          policy.public_send(:"#{action}?")
        end

        actual_actions.empty?
      end

      def failure_message
        message = +"#{policy_info} expected to #{description},"
        message << unexpected_text
        message << " for #{policy_info.user.inspect}."
        message
      end

      def failure_message_when_negated
        message = +"#{policy_info} expected to #{description},"
        message << unexpected_text
        message << " for #{policy_info.user.inspect}."
        message
      end

      private

      attr_reader :type, :expected_actions, :actual_actions, :policy, :policy_info

      def setup_matcher!(policy)
        @policy = policy
        @policy_info = Pundit::Matchers::Utils::PolicyInfo.new(policy)
      end

      def unexpected_text
        if actual_actions.empty?
          " but did not #{VERBS.dig(type, :actual_when_negated)} actions"
        else
          " but #{VERBS.dig(type, :actual)} #{actual_actions}"
        end
      end

      def check_arguments!
        missing_actions = expected_actions - policy_info.actions
        return if missing_actions.empty?

        raise ArgumentError, format(POLICY_DOES_NOT_IMPLEMENT_ERROR, actions: missing_actions)
      end
    end
  end
end
