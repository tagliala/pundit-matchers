# frozen_string_literal: true

require_relative 'only_actions_matcher'

module Pundit
  module Matchers
    module PermitOnlyActions
      def permit_only_actions(*actions)
        OnlyActionsMatcher.new(:permit, *actions)
      end
    end
  end
end
