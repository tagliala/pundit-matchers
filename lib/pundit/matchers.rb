# frozen_string_literal: true

require 'rspec/core'

require_relative 'matchers/permit_actions_matcher'

require_relative 'matchers/permit_attributes_matcher'

require_relative 'matchers/forbid_all_actions_matcher'
require_relative 'matchers/forbid_only_actions_matcher'

require_relative 'matchers/permit_all_actions_matcher'
require_relative 'matchers/permit_only_actions_matcher'

module Pundit
  module Matchers
    NEGABLE_MATCHERS = %i[
      action actions new_and_create_actions edit_and_update_actions mass_assignment_of
    ].freeze

    class Configuration
      attr_accessor :user_alias

      def initialize
        @user_alias = :user
      end
    end

    class << self
      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Pundit::Matchers::Configuration.new
      end
    end

    def permit_action(action)
      PermitActionsMatcher.new(action)
    end

    def permit_actions(*actions)
      PermitActionsMatcher.new(*actions)
    end

    def permit_mass_assignment_of(*attributes)
      PermitAttributesMatcher.new(*attributes)
    end

    def permit_new_and_create_actions
      PermitActionsMatcher.new(:new, :create)
    end

    def permit_edit_and_update_actions
      PermitActionsMatcher.new(:edit, :update)
    end

    def permit_all_actions
      PermitAllActionsMatcher.new
    end

    def permit_only_actions(*actions)
      PermitOnlyActionsMatcher.new(*actions)
    end

    def forbid_all_actions
      ForbidAllActionsMatcher.new
    end

    def forbid_only_actions(*actions)
      ForbidOnlyActionsMatcher.new(*actions)
    end
  end
end

RSpec.configure do |config|
  config.include Pundit::Matchers
end

Pundit::Matchers::NEGABLE_MATCHERS.each do |matcher|
  RSpec::Matchers.define_negated_matcher :"forbid_#{matcher}", :"permit_#{matcher}" do |description|
    description.gsub(/^permit/, 'forbid')
  end
end
