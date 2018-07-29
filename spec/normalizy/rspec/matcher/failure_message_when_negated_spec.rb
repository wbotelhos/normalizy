# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.failure_message_when_negated' do
  let!(:model) { Match }

  context 'with no :with expectation' do
    it do
      matcher = described_class.new(:downcase_field)

      matcher.from 'from'
      matcher.to   'from'
      matcher.matches? model.new

      expect(matcher.failure_message_when_negated).to eq %(expected: value != "from"\n     got: "from")
    end
  end

  context 'with :with expectation' do
    it do
      matcher = described_class.new(:downcase_field)

      matcher.with :downcase
      matcher.matches? model.new

      expect(matcher.failure_message_when_negated).to eq %(expected: value != downcase\n     got: downcase)
    end
  end
end
