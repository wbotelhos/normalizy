# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'filters:percent' do
  before do
    described_class.normalizy_rules = {}
  end

  specify do
    described_class.normalizy :amount_text, with: :percent

    expect(described_class.create(amount_text: '42.00 %').amount_text).to eq '42.00'
    expect(described_class.create(amount_text: '42.10 %').amount_text).to eq '42.10'
  end

  specify do
    described_class.normalizy :amount_cents, with: { percent: { type: :cents } }

    expect(described_class.create(amount_cents: '42.33 %').amount_cents).to be 4233
  end

  specify do
    described_class.normalizy :amount_cents, with: { percent: { cast: :to_i } }

    expect(described_class.create(amount_cents: '42.00 %').amount_cents).to be 42
  end

  specify do
    described_class.normalizy :amount, with: { percent: { cast: :to_d } }

    expect(described_class.create(amount: '1.23 %').amount).to eq 1.23.to_d
  end

  specify do
    described_class.normalizy :amount, with: { percent: { cast: :to_f, type: :cents } }

    expect(described_class.create(amount: '42.00 %').amount).to eq 4200.0.to_f
  end
end
