# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, '#add' do
  it 'adds filters to the built-in filters' do
    Normalizy.configure do |config|
      config.add :blacklist, :blacklist_filter
    end

    expect(Normalizy.config.filters).to eq(
      blacklist: :blacklist_filter,
      number:    Normalizy::Filters::Number,
      strip:     Normalizy::Filters::Strip
    )
  end
end
