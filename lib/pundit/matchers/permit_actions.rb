# frozen_string_literal: true

require_relative 'actions_matcher'

module Pundit
  module Matchers
    module PermitActions
      def permit_action(action)
        ActionsMatcher.new(:permit, action)
      end

      def permit_actions(*actions)
        ActionsMatcher.new(:permit, *actions)
      end

      def permit_new_and_create_actions
        ActionsMatcher.new(:permit, :new, :create)
      end

      def permit_edit_and_update_actions
        ActionsMatcher.new(:permit, :edit, :update)
      end
    end
  end
end
