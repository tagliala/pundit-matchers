# frozen_string_literal: true

require 'rspec/core'

module Pundit
  module Matchers
    require_relative 'matchers/actions'

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
  end

  ::RSpec.configure do |config|
    config.include Pundit::Matchers::Actions
  end

  RSpec::Matchers.define :forbid_mass_assignment_of do |attributes|
    # Map single object argument to an array, if necessary
    attributes = [attributes] unless attributes.is_a?(Array)

    match do |policy|
      return false if attributes.count < 1

      @allowed_attributes = attributes.select do |attribute|
        if defined? @action
          policy.send("permitted_attributes_for_#{@action}").include? attribute
        else
          policy.permitted_attributes.include? attribute
        end
      end

      @allowed_attributes.empty?
    end

    attr_reader :allowed_attributes

    chain :for_action do |action|
      @action = action
    end

    zero_attributes_failure_message = 'At least one attribute must be ' \
                                      'specified when using the forbid_mass_assignment_of matcher.'

    failure_message do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but permitted the mass assignment of the attributes ' \
          "#{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes}, but permitted the mass assignment of " \
          "the attributes #{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but permitted the mass assignment of the attributes ' \
          "#{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes}, but permitted the mass assignment of " \
          "the attributes #{allowed_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_mass_assignment_of do |attributes|
    # Map single object argument to an array, if necessary
    attributes = [attributes] unless attributes.is_a?(Array)

    match do |policy|
      return false if attributes.count < 1

      @forbidden_attributes = attributes.select do |attribute|
        if defined? @action
          !policy.send("permitted_attributes_for_#{@action}").include? attribute
        else
          !policy.permitted_attributes.include? attribute
        end
      end

      @forbidden_attributes.empty?
    end

    attr_reader :forbidden_attributes

    chain :for_action do |action|
      @action = action
    end

    zero_attributes_failure_message = 'At least one attribute must be ' \
                                      'specified when using the permit_mass_assignment_of matcher.'

    failure_message do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but forbade the mass assignment of the attributes ' \
          "#{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to permit the mass assignment of the " \
          "attributes #{attributes}, but forbade the mass assignment of the " \
          "attributes #{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if attributes.count.zero?
        zero_attributes_failure_message
      elsif defined? @action
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes} when authorising the #{@action} action, " \
          'but forbade the mass assignment of the attributes ' \
          "#{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      else
        "#{policy.class} expected to forbid the mass assignment of the " \
          "attributes #{attributes}, but forbade the mass assignment of the " \
          "attributes #{forbidden_attributes} for " \
          "#{policy.public_send(Pundit::Matchers.configuration.user_alias).inspect}."
      end
    end
  end
end

if defined?(Pundit)
  RSpec.configure do |config|
    config.include Pundit::Matchers
  end
end
