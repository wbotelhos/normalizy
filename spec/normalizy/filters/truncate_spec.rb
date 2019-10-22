# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Filters::Truncate do
  context 'when :limit options is not given' do
    it { expect(subject.call('miss')).to eq 'miss' }
  end

  context 'when :limit is given' do
    it { expect(subject.call('abcdefghijklmnopkrstuvxyz', limit: 3)).to eq 'abc' }
  end
end
