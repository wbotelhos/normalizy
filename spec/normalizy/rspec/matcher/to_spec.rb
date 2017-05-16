# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.to' do
  let!(:matcher) { described_class.new :name }
  let!(:model)   { User }

  it 'caches the value' do
    matcher.to :to

    expect(matcher.instance_variable_get(:@to)).to eq :to
  end

  it 'returns it self' do
    expect(matcher.to(:to)).to be matcher
  end
end
