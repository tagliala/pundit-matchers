# frozen_string_literal: true

require_relative 'all_actions_matcher'

module Pundit
  module Matchers
    module ForbidAllActions
      def forbid_all_actions
        AllActionsMatcher.new(:forbid)
      end
    end
  end
end
