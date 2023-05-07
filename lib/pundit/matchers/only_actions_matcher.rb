# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class OnlyActionsMatcher < ActionsMatcher
      def description
        "#{VERBS.dig(type, :expected)} only #{expected_actions}"
      end

      def does_not_match?(policy)
        return does_not_match?(policy) if type == :permit

        setup_matcher! policy
        check_arguments!

        @actual_actions = policy_info.forbidden_actions - expected_actions
        @unexpected_actions = policy_info.permitted_actions & expected_actions

        actual_actions.empty? && unexpected_actions.empty?
      end

      def matches?(policy)
        return does_not_match?(policy) if type == :forbid

        setup_matcher! policy
        check_arguments!

        @actual_actions = policy_info.permitted_actions - expected_actions
        @unexpected_actions = policy_info.forbidden_actions & expected_actions

        actual_actions.empty? && unexpected_actions.empty?
      end

      private

      attr_reader :unexpected_actions

      def unexpected_text
        text =
          if actual_actions.empty?
            +" but did not #{VERBS.dig(type, :expected)} actions"
          else
            +" but #{VERBS.dig(type, :actual_when_negated)} #{actual_actions}"
          end
        text << " and #{VERBS.dig(type, :actual)} #{unexpected_actions}" unless unexpected_actions.empty?
        text
      end
    end
  end
end
