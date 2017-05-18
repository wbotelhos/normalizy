# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, 'filters' do
  it 'loads some filters' do
    expect(subject.filters).to eq(
      money:  Normalizy::Filters::Money,
      number: Normalizy::Filters::Number,
      strip:  Normalizy::Filters::Strip
    )
  end
end
