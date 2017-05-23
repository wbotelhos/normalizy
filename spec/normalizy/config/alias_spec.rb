# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, '#alias' do
  it 'accepts alias' do
    Normalizy.configure do |config|
      config.alias :email, :downcase
    end

    expect(Alias.create(email: 'Botelho').email).to eq 'botelho'
  end

  it 'accepts alias with options' do
    Normalizy.configure do |config|
      config.alias :with_arg, strip: { side: :left }
    end

    expect(Alias.create(with_arg_field: '  trim').with_arg_field).to eq 'trim'
  end

  it 'accepts late options' do
    Normalizy.configure do |config|
      config.alias :with_inline_arg, :strip
    end

    expect(Alias.create(with_inline_arg_field: '  trim').with_inline_arg_field).to eq 'trim'
  end
end
