# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelDate, 'filters:date' do
  specify do
    expected = Time.new(1984, 10, 23, 0, 0, 0, 0)

    expect(described_class.create(date: '1984-10-23').date).to eq expected
  end

  specify do
    expected = Time.new(1984, 10, 23, 0, 0, 0, 0)

    expect(described_class.create(date_format: '84/10/23').date_format).to eq expected
  end

  specify do
    hours    = offset_in_hours('America/Sao_Paulo')
    expected = Time.new(1984, 10, 23, 0, 0, 0, 0) + (hours.hours * -1)

    expect(described_class.create(date_time_zone: '1984-10-23').date_time_zone).to eq expected
  end
end
