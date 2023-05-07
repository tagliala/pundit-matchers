# frozen_string_literal: true

require_relative 'all_actions_matcher'

module Pundit
  module Matchers
    module PermitAllActions
      def permit_all_actions
        AllActionsMatcher.new(:permit)
      end
    end
  end
end
