# frozen_string_literal: true

RSpec.describe ModelSlug, 'filters:slug' do
  from = 'The Títle'
  to = 'the-title'

  it { expect(described_class.create(permalink: from).permalink).to eq to }

  it { expect(described_class.create(title: from).slug).to eq to }

  it { expect(described_class.create(title: from).title).to eq from }
end
