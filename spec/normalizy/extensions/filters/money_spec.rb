# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelMoney, 'filters:money' do
  specify do
    expect(described_class.create(text: '$ 42.00').text).to eq '42.00'
    expect(described_class.create(text: '$ 42.10').text).to eq '42.10'
  end

  specify do
    expect(described_class.create(cents_type: '$ 42.33').cents_type).to eq '4233'
  end

  specify do
    expect(described_class.create(cast_to_i: '$ 42.00').cast_to_i).to be 42
  end

  specify do
    expect(described_class.create(cast_to_d: '$ 1.23').cast_to_d).to eq 1.23
  end

  specify do
    expect(described_class.create(cents_type_and_cast_to_f: '$ 42.00').cents_type_and_cast_to_f).to eq 4200.0
  end

  specify do
    expect(described_class.create(cents_type_and_cast_to_i: '$ 42.00').cents_type_and_cast_to_i).to eq 4200
  end
end
