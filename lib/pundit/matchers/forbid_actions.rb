# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module ForbidActions
      def forbid_action(action)
        ForbidActionsMatcher.new(action)
      end

      def forbid_actions(*actions)
        ForbidActionsMatcher.new(*actions)
      end

      def forbid_new_and_create_actions
        ForbidActionsMatcher.new(:new, :create)
      end

      def forbid_edit_and_update_actions
        ForbidActionsMatcher.new(:edit, :update)
      end

      class ForbidActionsMatcher < Pundit::Matchers::ActionsMatcher
        def matches?(policy)
          raise ArgumentError, 'At least one action must be specified' if expected_actions.count < 1

          super

          @actual_actions = expected_actions & policy_info.permitted_actions

          actual_actions.empty?
        end

        private

        def verb
          'forbid'
        end

        def other_verb
          'permitted'
        end
      end
    end
  end
end
