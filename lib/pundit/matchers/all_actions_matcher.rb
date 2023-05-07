# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    class AllActionsMatcher < ActionsMatcher
      def initialize(type)
        super(type, :all)
      end

      def description
        "#{VERBS.dig(type, :expected)} all actions"
      end

      def does_not_match?(policy)
        return match?(policy) if type == :permit

        setup_matcher! policy

        @actual_actions = policy_info.actions - policy_info.forbidden_actions

        actual_actions.empty?
      end

      def matches?(policy)
        return does_not_match?(policy) if type == :forbid

        setup_matcher! policy

        @actual_actions = policy_info.actions - policy_info.permitted_actions

        actual_actions.empty?
      end
    end
  end
end
