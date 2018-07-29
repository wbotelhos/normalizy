# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Extension, ':normalizy_rules' do
  let!(:model) { Rule }

  before { model.normalizy_rules = {} }

  context 'with default' do
    before do
      Normalizy.configure do |config|
        config.default_filters = :squish
      end
    end

    it do
      model.normalizy :name

      expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: nil }])
    end

    it do
      model.normalizy :name, with: :upcase

      expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: :upcase }])
    end

    it do
      expected = { name: [{ block: nil, options: {}, rules: [:upcase, 'blank', { trim: { side: :left } }] }] }

      model.normalizy :name, with: [:upcase, 'blank', { trim: { side: :left } }]

      expect(model.normalizy_rules).to eq expected
    end

    it do
      model.normalizy :name, with: [:upcase, { trim: { side: :left } }]
      model.normalizy :name, with: :squish
      model.normalizy :name, with: [:upcase, { trim: { side: :right } }]
      model.normalizy :name, with: :squish

      expect(model.normalizy_rules).to eq(
        name: [
          { block: nil, options: {}, rules: [:upcase, { trim: { side: :left } }] },
          { block: nil, options: {}, rules: :squish },
          { block: nil, options: {}, rules: [:upcase, { trim: { side: :right } }] },
          { block: nil, options: {}, rules: :squish }
        ]
      )
    end

    it do
      model.normalizy :email, :name

      expect(model.normalizy_rules).to eq(
        email: [{ block: nil, options: {}, rules: nil }],
        name:  [{ block: nil, options: {}, rules: nil }]
      )
    end

    it do
      model.normalizy :email, :name, with: :upcase

      expect(model.normalizy_rules).to eq(
        name:  [{ block: nil, options: {}, rules: :upcase }],
        email: [{ block: nil, options: {}, rules: :upcase }]
      )
    end

    it do
      model.normalizy :email, :name, with: [:upcase, :blank, { trim: { side: :left } }]

      expect(model.normalizy_rules).to eq(
        email: [{ block: nil, options: {}, rules: [:upcase, :blank, { trim: { side: :left } }] }],
        name:  [{ block: nil, options: {}, rules: [:upcase, :blank, { trim: { side: :left } }] }]
      )
    end

    it do
      model.normalizy :email, :name, with: [:upcase, { trim: { side: :left } }]
      model.normalizy :email, :name, with: :squish
      model.normalizy :email, :name, with: [:upcase, { trim: { side: :right } }]
      model.normalizy :email, :name, with: :squish

      expect(model.normalizy_rules).to eq(
        email: [
          { block: nil, options: {}, rules: [:upcase, { trim: { side: :left } }] },
          { block: nil, options: {}, rules: :squish },
          { block: nil, options: {}, rules: [:upcase, { trim: { side: :right } }] },
          { block: nil, options: {}, rules: :squish }
        ],
        name:  [
          { block: nil, options: {}, rules: [:upcase, { trim: { side: :left } }] },
          { block: nil, options: {}, rules: :squish },
          { block: nil, options: {}, rules: [:upcase, { trim: { side: :right } }] },
          { block: nil, options: {}, rules: :squish }
        ]
      )
    end
  end

  context 'with no default' do
    before do
      Normalizy.configure do |config|
        config.default_filters = []
      end
    end

    it do
      model.normalizy :name

      expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: nil }])
    end

    it do
      model.normalizy :name, with: :upcase

      expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: :upcase }])
    end

    it do
      model.normalizy :name, with: %i[upcase blank]

      expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: %i[upcase blank] }])
    end

    it do
      model.normalizy :name, with: :upcase
      model.normalizy :name, with: :squish
      model.normalizy :name, with: :upcase

      expect(model.normalizy_rules).to eq(
        name: [
          { block: nil, options: {}, rules: :upcase },
          { block: nil, options: {}, rules: :squish },
          { block: nil, options: {}, rules: :upcase }
        ]
      )
    end

    it do
      model.normalizy :email, :name

      expect(model.normalizy_rules).to eq(
        email: [{ block: nil, options: {}, rules: nil }],
        name:  [{ block: nil, options: {}, rules: nil }]
      )
    end

    it do
      model.normalizy :email, :name, with: :upcase

      expect(model.normalizy_rules).to eq(
        email: [{ block: nil, options: {}, rules: :upcase }],
        name:  [{ block: nil, options: {}, rules: :upcase }]
      )
    end

    it do
      model.normalizy :email, :name, with: %i[upcase blank]

      expect(model.normalizy_rules).to eq(
        email: [{ block: nil, options: {}, rules: %i[upcase blank] }],
        name:  [{ block: nil, options: {}, rules: %i[upcase blank] }]
      )
    end

    it do
      model.normalizy :email, :name, with: :upcase
      model.normalizy :email, :name, with: :squish
      model.normalizy :email, :name, with: :upcase

      expect(model.normalizy_rules).to eq(
        email: [
          { block: nil, options: {}, rules: :upcase },
          { block: nil, options: {}, rules: :squish },
          { block: nil, options: {}, rules: :upcase }
        ],
        name:  [
          { block: nil, options: {}, rules: :upcase },
          { block: nil, options: {}, rules: :squish },
          { block: nil, options: {}, rules: :upcase }
        ]
      )
    end
  end

  context 'when block is given' do
    let!(:block) { ->(value) { value.downcase } }

    it do
      model.normalizy :name, &block

      expect(model.normalizy_rules[:name][0][:block]).to eq block
    end
  end
end
