# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelStrip, 'filters:strip' do
  specify do
    expect(described_class.create(strip: '  Botelho  ').strip).to eq 'Botelho'
  end

  specify do
    expect(described_class.create(strip_side_left: '  Botelho  ').strip_side_left).to eq 'Botelho  '
  end

  specify do
    expect(described_class.create(strip_side_right: '  Botelho  ').strip_side_right).to eq '  Botelho'
  end

  specify do
    expect(described_class.create(strip_side_both: '  Botelho  ').strip_side_both).to eq 'Botelho'
  end
end
