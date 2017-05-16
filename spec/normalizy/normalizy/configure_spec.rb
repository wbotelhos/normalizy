# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy, '#configure' do
  it 'yields the default config' do
    described_class.configure do |conf|
      expect(conf).to be_a_instance_of Normalizy::Config
    end
  end
end
