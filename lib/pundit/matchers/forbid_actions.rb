# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module ForbidActions
      def forbid_action(action)
        ActionsMatcher.new(:forbid, action)
      end

      def forbid_actions(*actions)
        ActionsMatcher.new(:forbid, *actions)
      end

      def forbid_new_and_create_actions
        ActionsMatcher.new(:forbid, :new, :create)
      end

      def forbid_edit_and_update_actions
        ActionsMatcher.new(:forbid, :edit, :update)
      end
    end
  end
end
