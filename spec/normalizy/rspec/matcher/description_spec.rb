# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.description' do
  let!(:matcher) { described_class.new :name }

  before do
    matcher.from :from
    matcher.to   :to
  end

  context 'with no :with expectation' do
    specify do
      expect(matcher.description).to eq 'normalizy name from "from" to "to"'
    end
  end

  context 'with :with expectation' do
    before { matcher.with :blank }

    specify do
      expect(matcher.description).to eq 'normalizy name with blank'
    end
  end
end
