# frozen_string_literal: true

RSpec.describe Normalizy::RSpec::Matcher, '.from' do
  it 'caches the value' do
    matcher = described_class.new(:downcase_field)

    matcher.from :from

    expect(matcher.instance_variable_get(:@from)).to eq :from
  end

  it 'returns it self' do
    matcher = described_class.new(:downcase_field)

    expect(matcher.from(:from)).to be matcher
  end
end
