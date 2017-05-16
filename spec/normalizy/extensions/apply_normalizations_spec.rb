# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '#apply_normalizations' do
  context 'when object has no normalizy' do
    let!(:object) { Clean.create name: '  washington  Botelho  ' }

    it 'does not normalize' do
      expect(object.name).to eq '  washington  Botelho  '
    end
  end

  context 'when object has normalizy' do
    let!(:object) { User.new name: '  Washington  Fuck  Botelho  ' }

    before { object.class.normalizy_rules = {} }

    context 'when a rule is not given' do
      context 'and no block' do
        before do
          Normalizy.configure do |config|
            config.default_filters = :squish
          end

          object.class.normalizy :name
        end

        it 'uses the default' do
          object.save

          expect(object.name).to eq 'Washington Fuck Botelho'
        end
      end

      context 'but block is' do
        let!(:block) { ->(value) { value.upcase } }

        before do
          Normalizy.configure do |config|
            config.add :blacklist, Normalizy::Filters::Blacklist
          end
        end

        it 'executes the block' do
          object.class.normalizy :name, with: block

          object.save

          expect(object.name).to eq '  WASHINGTON  FUCK  BOTELHO  '
        end
      end
    end

    context 'when a rule is given' do
      context 'as symbol format' do
        before { object.class.normalizy :name, with: :squish }

        specify do
          object.save

          expect(object.name).to eq 'Washington Fuck Botelho'
        end
      end

      context 'as array of symbol format' do
        before { object.class.normalizy :name, with: [:squish] }

        specify do
          object.save

          expect(object.name).to eq 'Washington Fuck Botelho'
        end
      end

      context 'as a hash format' do
        context 'and filter does not receives options' do
          before { object.class.normalizy :name, with: { squish: :options } }

          specify do
            object.save

            expect(object.name).to eq 'Washington Fuck Botelho'
          end
        end

        context 'and filter receives options' do
          before { object.class.normalizy :name, with: { strip: { side: :left } } }

          specify do
            object.save

            expect(object.name).to eq 'Washington  Fuck  Botelho  '
          end
        end
      end

      context 'as a module' do
        before { object.class.normalizy :name, with: Normalizy::Filters::Blacklist }

        specify do
          object.save

          expect(object.name).to eq '  Washington  filtered  Botelho  '
        end
      end

      context 'and block too' do
        let!(:block) { ->(value) { value.upcase } }

        before do
          Normalizy.configure do |config|
            config.add :blacklist, Normalizy::Filters::Blacklist
          end
        end

        it 'runs after rules' do
          object.class.normalizy :name, with: :blacklist, &block

          object.save

          expect(object.name).to eq '  WASHINGTON  FILTERED  BOTELHO  '
        end
      end
    end

    context 'when no filter match' do
      context 'and object has a method that responds' do
        context 'with no options on rule' do
          it 'runs the native method with empty options' do
            object.class.normalizy :name, with: :custom_reverse

            object.save

            expect(object.name).to eq '  ohletoB  kcuF  notgnihsaW  .{}.custom'
          end
        end

        context 'with no options on rule' do
          it 'runs the native method with given options' do
            object.class.normalizy :name, with: { custom_reverse: :options }

            object.save

            expect(object.name).to eq '  ohletoB  kcuF  notgnihsaW  .options.custom'
          end
        end
      end

      context 'and attribute has not a method that responds' do
        context 'but attribute has a native method like it' do
          it 'runs the native method' do
            object.class.normalizy :name, with: :split

            object.save

            expect(object.name).to eq %(["Washington", "Fuck", "Botelho"])
          end
        end
      end
    end
  end
end
