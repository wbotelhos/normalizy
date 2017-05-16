# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.failure_message_when_negated' do
  let!(:matcher) { described_class.new :name }
  let!(:model)   { User }

  before do
    matcher.from :from
    matcher.to :to
    matcher.matches? model.new
  end

  context 'with no :with expectation' do
    specify do
      expect(matcher.failure_message_when_negated).to eq %(expected: value != "to"\n     got: "from")
    end
  end

  context 'with :with expectation' do
    before do
      model.normalizy_rules = {}

      matcher.with :blank
    end

    it 'will be nil since script does not initialized it with memo hash' do
      expect(matcher.failure_message_when_negated).to eq %(expected: value != blank\n     got: nil)
    end
  end
end
