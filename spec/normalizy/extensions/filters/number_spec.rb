# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'filters:number' do
  before { described_class.normalizy_rules = {} }

  specify do
    described_class.normalizy :name, with: :number

    expect(described_class.create(name: 'Washington 32').name).to eq '32'
  end
end
