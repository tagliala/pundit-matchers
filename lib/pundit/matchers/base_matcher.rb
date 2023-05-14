# frozen_string_literal: true

require_relative 'utils/policy_info'

module Pundit
  module Matchers
    class BaseMatcher
      private

      attr_reader :policy_info

      def setup_policy_info!(policy)
        @policy_info = Pundit::Matchers::Utils::PolicyInfo.new(policy)
      end

      def user_message
        " for '#{policy_info.user}'"
      end
    end
  end
end
