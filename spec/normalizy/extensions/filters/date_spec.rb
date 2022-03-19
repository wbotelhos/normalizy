# frozen_string_literal: true

RSpec.describe ModelDate, 'filters:date' do
  it { expect(described_class.create(date: '1984-10-23').date).to eq(Time.new(1984, 10, 23, 0, 0, 0, 0)) }
  it { expect(described_class.create(date_format: '84/10/23').date_format).to eq(Time.new(1984, 10, 23, 0, 0, 0, 0)) }

  it do
    hours    = ActiveSupport::TimeZone['Brasilia'].utc_offset / 3600.0
    expected = Time.new(1984, 10, 23, 0, 0, 0, 0) + (hours.hours * -1)

    expect(described_class.create(date_time_zone: '1984-10-23').date_time_zone).to eq expected
  end

  it 'normalizys end date' do
    expect(described_class.new(date_time_end: Date.new(1984)).date_time_end.to_s).to eq(Time.new(1984).end_of_day.to_s)
  end

  it 'normalizys begin date' do
    expect(described_class.new(date_time_begin: Date.new(1984, 10, 23)).date_time_begin).to eq(Time.new(1984, 10, 23))
  end
end
