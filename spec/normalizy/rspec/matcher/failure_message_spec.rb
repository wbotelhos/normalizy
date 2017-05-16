# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.failure_message' do
  let!(:matcher) { described_class.new :name }
  let!(:model)   { User }

  before do
    model.normalizy_rules = {}

    matcher.from :from
    matcher.to :to
    matcher.matches? model.new
  end

  context 'with no :with expectation' do
    specify do
      expect(matcher.failure_message).to eq %(expected: "to"\n     got: "from")
    end
  end

  context 'when :with is expectated' do
    before { matcher.with :trim }

    context 'and attribute has no :with rules' do
      specify do
        expect(matcher.failure_message).to eq %(expected: trim\n     got: nil)
      end
    end

    context 'and attribute has a symbol as :with rule' do
      before do
        model.normalizy_rules = {
          name: [{ block: nil, options: {}, rules: :blank }]
        }
      end

      specify do
        expect(matcher.failure_message).to eq %(expected: trim\n     got: blank)
      end
    end

    context 'and attribute has an array as :with rule' do
      before do
        model.normalizy_rules = {
          name: [{ block: nil, options: {}, rules: [:blank] }]
        }
      end

      specify do
        expect(matcher.failure_message).to eq %(expected: trim\n     got: blank)
      end
    end

    context 'and attribute has a hash as :with rule' do
      before do
        model.normalizy_rules = {
          name: [
            { block: nil, options: {}, rules: { trim: { side: :left } } }
          ]
        }
      end

      specify do
        expect(matcher.failure_message).to eq %(expected: trim\n     got: {:trim=>{:side=>:left}})
      end
    end
  end
end
