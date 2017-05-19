# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'filters:date' do
  before do
    described_class.normalizy_rules = {}
  end

  specify do
    described_class.normalizy :birthday, with: :date

    expected = Time.new(1984, 10, 23, 0, 0, 0, 0)

    expect(described_class.create(birthday: '1984-10-23').birthday).to eq expected
  end

  specify do
    described_class.normalizy :birthday, with: { date: { format: '%y/%m/%d' } }

    expected = Time.new(1984, 10, 23, 0, 0, 0, 0)

    expect(described_class.create(birthday: '84/10/23').birthday).to eq expected
  end

  specify do
    described_class.normalizy :birthday, with: { date: { time_zone: 'Brasilia' } }

    hours    = offset_in_hours('America/Sao_Paulo')
    expected = Time.new(1984, 10, 23, 0, 0, 0, 0) + (hours.hours * -1)

    expect(described_class.create(birthday: '1984-10-23').birthday).to eq expected
  end
end
