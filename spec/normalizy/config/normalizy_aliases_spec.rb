# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, 'normalizy_aliases' do
  it 'has the right defaults' do
    expect(subject.normalizy_aliases).to eq({})
  end
end
