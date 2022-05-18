# frozen_string_literal: true

RSpec.describe Normalizy::Filters::Truncate do
  context 'when :limit options is not given' do
    it { expect(subject.call('miss')).to eq 'miss' }
  end

  context 'when :limit options is not a number' do
    it { expect(subject.call('miss', limit: 'wrong')).to eq 'miss' }
  end

  context 'when input value is not a string' do
    it { expect(subject.call(10)).to eq 10 }
  end

  context 'when :limit is given' do
    it { expect(subject.call('abcdefghijklmnopkrstuvxyz', limit: 3)).to eq 'abc' }
  end
end
