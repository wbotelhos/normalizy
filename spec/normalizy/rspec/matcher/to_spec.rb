# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.to' do
  it 'caches the value' do
    matcher = described_class.new(:downcase)

    matcher.to :to

    expect(matcher.instance_variable_get(:@to)).to eq :to
  end

  it 'returns it self' do
    matcher = described_class.new(:downcase)

    expect(matcher.to(:to)).to be matcher
  end
end
