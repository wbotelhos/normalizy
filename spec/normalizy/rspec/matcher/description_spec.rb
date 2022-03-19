# frozen_string_literal: true

RSpec.describe Normalizy::RSpec::Matcher, '.description' do
  let!(:matcher) { described_class.new :name }

  context 'with no :with expectation' do
    it do
      matcher.from :from
      matcher.to   :to

      expect(matcher.description).to eq 'normalizy name from "from" to "to"'
    end
  end

  context 'with :with expectation' do
    it do
      matcher.with :blank

      matcher.from :from
      matcher.to   :to

      expect(matcher.description).to eq 'normalizy name with blank'
    end
  end
end
