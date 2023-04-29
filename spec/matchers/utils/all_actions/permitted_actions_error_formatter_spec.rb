# frozen_string_literal: true

require 'rspec/core'

RSpec.describe Pundit::Matchers::Utils::AllActions::PermittedActionsErrorFormatter do
  subject(:error_message_formatter) do
    described_class.new(matcher)
  end

  let(:matcher) do
    Pundit::Matchers::Utils::AllActions::PermittedActionsMatcher.new(policy)
  end

  let(:policy_class) { TestCreateUpdatePolicy }
  let(:policy) { policy_class.new(update: true) }

  describe '#message' do
    subject(:message) { error_message_formatter.message }

    it 'includes missed actions in message' do
      expect(message).to eq('TestPolicy expected to have all actions permitted, but [:create] is forbidden')
    end
  end
end
