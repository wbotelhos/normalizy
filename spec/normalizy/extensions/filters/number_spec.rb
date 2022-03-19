# frozen_string_literal: true

RSpec.describe ModelNumber, 'filters:number' do
  it do
    expect(described_class.create(number: 'Botelho 32').number).to eq '32'
  end
end
