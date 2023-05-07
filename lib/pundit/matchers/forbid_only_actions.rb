# frozen_string_literal: true

require_relative 'only_actions_matcher'

module Pundit
  module Matchers
    module ForbidOnlyActions
      def forbid_only_actions(*actions)
        OnlyActionsMatcher.new(:forbid, *actions)
      end
    end
  end
end
