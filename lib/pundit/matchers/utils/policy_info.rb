# frozen_string_literal: true

module Pundit
  module Matchers
    module Utils
      # Collects information about a given policy class.
      class PolicyInfo
        USER_NOT_IMPLEMENTED_ERROR = <<~MSG
          '%<policy>s' does not implement '%<user_alias>s'. You may want to
          configure an alias, which you can do as follows:

          Pundit::Matchers.configure do |config|
            config.user_alias = :account
          end
        MSG

        attr_reader :policy

        def initialize(policy)
          @policy = policy
          check_user_alias!
        end

        def to_s
          policy.class.name
        end

        def user
          @user ||= policy.public_send(user_alias)
        end

        def actions
          @actions ||= begin
            policy_methods = @policy.public_methods - Object.instance_methods
            policy_methods.grep(/\?$/).sort.map { |policy_method| policy_method.to_s.delete_suffix('?').to_sym }
          end
        end

        def permitted_actions
          @permitted_actions ||= actions.select { |action| policy.public_send("#{action}?") }
        end

        def forbidden_actions
          @forbidden_actions ||= actions - permitted_actions
        end

        private

        def user_alias
          @user_alias ||= Pundit::Matchers.configuration.user_alias
        end

        def check_user_alias!
          return if policy.respond_to?(user_alias)

          raise ArgumentError, format(USER_NOT_IMPLEMENTED_ERROR, policy: self, user_alias: user_alias)
        end
      end
    end
  end
end
