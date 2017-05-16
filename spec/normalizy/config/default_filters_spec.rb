# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, 'default_filters' do
  context 'when get' do
    it 'returns the default filters' do
      expect(subject.default_filters).to eq({})
    end
  end

  context 'when set' do
    before { subject.default_filters = :blank }

    it 'keeps the original' do
      expect(subject.default_filters).to eq :blank
    end
  end
end
