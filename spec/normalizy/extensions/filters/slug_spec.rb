# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelSlug, 'filters:slug' do
  from = 'The Títle'
  to   = 'the-title'

  specify { expect(described_class.create(permalink: from).permalink).to eq to }

  specify { expect(described_class.create(title: from).slug).to eq to }
end
