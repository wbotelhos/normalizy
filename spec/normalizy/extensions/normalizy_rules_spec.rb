# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Extension, ':normalizy_rules' do
  let!(:model) { User }

  before { model.normalizy_rules = {} }

  context 'with default' do
    before do
      Normalizy.configure do |config|
        config.default_filters = :squish
      end
    end

    context 'with one field' do
      context 'with no rules' do
        before { model.normalizy :name }

        it 'appends default' do
          expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: :squish }])
        end
      end

      context 'with one rule' do
        before { model.normalizy :name, with: :upcase }

        specify do
          expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: :upcase }])
        end
      end

      context 'with multiple rules' do
        before { model.normalizy :name, with: [:upcase, 'blank', { trim: { side: :left } }] }

        specify do
          expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: [:upcase, 'blank', { trim: { side: :left } }] }])
        end
      end

      context 'with multiple normalizes including repeated rules' do
        before do
          model.normalizy :name, with: [:upcase, { trim: { side: :left } }]
          model.normalizy :name, with: :squish
          model.normalizy :name, with: [:upcase, { trim: { side: :right } }]
          model.normalizy :name, with: :squish
        end

        it 'includes all' do
          expect(model.normalizy_rules).to eq(
            name: [
              { block: nil, options: {}, rules: [:upcase, { trim: { side: :left } }] },
              { block: nil, options: {}, rules: :squish },
              { block: nil, options: {}, rules: [:upcase, { trim: { side: :right } }] },
              { block: nil, options: {}, rules: :squish }
            ]
          )
        end
      end
    end

    context 'with multiple fields' do
      context 'with no rule' do
        before { model.normalizy :email, :name }

        it 'appends default' do
          expect(model.normalizy_rules).to eq(
            email: [{ block: nil, options: {}, rules: :squish }],
            name:  [{ block: nil, options: {}, rules: :squish }]
          )
        end
      end

      context 'with one rule' do
        before { model.normalizy :email, :name, with: :upcase }

        specify do
          expect(model.normalizy_rules).to eq(
            name:  [{ block: nil, options: {}, rules: :upcase }],
            email: [{ block: nil, options: {}, rules: :upcase }]
          )
        end
      end

      context 'with multiple rules' do
        before { model.normalizy :email, :name, with: [:upcase, :blank, { trim: { side: :left } }] }

        specify do
          expect(model.normalizy_rules).to eq(
            email: [{ block: nil, options: {}, rules: [:upcase, :blank, { trim: { side: :left } }] }],
            name:  [{ block: nil, options: {}, rules: [:upcase, :blank, { trim: { side: :left } }] }]
          )
        end
      end

      context 'with multiple normalizes including repeated rules' do
        before do
          model.normalizy :email, :name, with: [:upcase, { trim: { side: :left } }]
          model.normalizy :email, :name, with: :squish
          model.normalizy :email, :name, with: [:upcase, { trim: { side: :right } }]
          model.normalizy :email, :name, with: :squish
        end

        it 'merges all as unique with the last one having priority in deep levels too' do
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
    end
  end

  context 'with no default' do
    before do
      Normalizy.configure do |config|
        config.default_filters = []
      end
    end

    context 'with one field' do
      context 'with no rules' do
        before { model.normalizy :name }

        specify do
          expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: [] }])
        end
      end

      context 'with one rule' do
        before { model.normalizy :name, with: :upcase }

        specify do
          expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: :upcase }])
        end
      end

      context 'with multiple rules' do
        before { model.normalizy :name, with: %i[upcase blank] }

        specify do
          expect(model.normalizy_rules).to eq(name: [{ block: nil, options: {}, rules: %i[upcase blank] }])
        end
      end

      context 'with multiple normalizes including repeated rules' do
        before do
          model.normalizy :name, with: :upcase
          model.normalizy :name, with: :squish
          model.normalizy :name, with: :upcase
        end

        it 'merges all as unique' do
          expect(model.normalizy_rules).to eq(
            name: [
              { block: nil, options: {}, rules: :upcase },
              { block: nil, options: {}, rules: :squish },
              { block: nil, options: {}, rules: :upcase }
            ]
          )
        end
      end
    end

    context 'with multiple fields' do
      context 'with no rule' do
        before { model.normalizy :email, :name }

        specify do
          expect(model.normalizy_rules).to eq(
            email: [{ block: nil, options: {}, rules: [] }],
            name:  [{ block: nil, options: {}, rules: [] }]
          )
        end
      end

      context 'with one rule' do
        before { model.normalizy :email, :name, with: :upcase }

        specify do
          expect(model.normalizy_rules).to eq(
            email: [{ block: nil, options: {}, rules: :upcase }],
            name:  [{ block: nil, options: {}, rules: :upcase }]
          )
        end
      end

      context 'with multiple rules' do
        before { model.normalizy :email, :name, with: %i[upcase blank] }

        specify do
          expect(model.normalizy_rules).to eq(
            email: [{ block: nil, options: {}, rules: %i[upcase blank] }],
            name:  [{ block: nil, options: {}, rules: %i[upcase blank] }]
          )
        end
      end

      context 'with multiple normalizes including repeated rules' do
        before do
          model.normalizy :email, :name, with: :upcase
          model.normalizy :email, :name, with: :squish
          model.normalizy :email, :name, with: :upcase
        end

        it 'merges all as unique' do
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
    end
  end

  context 'when block is given' do
    let!(:block) { ->(value) { value.downcase } }

    before { model.normalizy(:name, &block) }

    specify do
      expect(model.normalizy_rules[:name][0][:block]).to eq block
    end
  end
end
