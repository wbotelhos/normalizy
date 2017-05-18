# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'filters:strip' do
  before do
    described_class.normalizy_rules = {}
  end

  specify do
    described_class.normalizy :name, with: :strip

    expect(described_class.create(name: '  Washington  ').name).to eq 'Washington'
  end

  specify do
    described_class.normalizy :name, with: { strip: { side: :left } }

    expect(described_class.create(name: '  Washington  ').name).to eq 'Washington  '
  end
end
