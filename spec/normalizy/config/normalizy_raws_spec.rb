# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, 'normalizy_raws' do
  it 'has the right defaults' do
    expect(subject.normalizy_raws).to eq %i[date money number]
  end
end
