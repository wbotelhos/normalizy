# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.from' do
  let!(:matcher) { described_class.new :name }
  let!(:model)   { User }

  it 'caches the value' do
    matcher.from :from

    expect(matcher.instance_variable_get(:@from)).to eq :from
  end

  it 'returns it self' do
    expect(matcher.from(:from)).to be matcher
  end
end
