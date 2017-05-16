# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'active_record' do
  xit 'norm the object' do
    matcher.matches?(object)

    expect(matcher.instance_variable_get(:@subject)).to eq object
  end
end
