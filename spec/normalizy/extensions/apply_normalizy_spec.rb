# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '#apply_normalizy' do
  context 'when object has no normalizy' do
    let!(:object) { Clean.create name: '  washington  Botelho  ' }

    it 'does not normalize' do
      expect(object.name).to eq '  washington  Botelho  '
    end
  end

  context 'when object has normalizy' do
    let!(:object) { User.new name: '  Washington  Fuck  Botelho  ' }

    before { object.class.normalizy_rules = {} }

    context 'when a filter is not given' do
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

        it 'executes the block' do
          object.class.normalizy :name, with: block

          object.save

          expect(object.name).to eq '  WASHINGTON  FUCK  BOTELHO  '
        end
      end
    end

    context 'when a filter is given' do
      context 'as a symbol' do
        before { object.class.normalizy :name, with: :squish }

        specify do
          object.save

          expect(object.name).to eq 'Washington Fuck Botelho'
        end
      end

      context 'as array of symbol' do
        before { object.class.normalizy :name, with: [:squish] }

        specify do
          object.save

          expect(object.name).to eq 'Washington Fuck Botelho'
        end
      end

      context 'as a hash' do
        context 'with a filter that does not accepts options' do
          before { object.class.normalizy :name, with: { squish: { ignored: true } } }

          it 'executes the filter ignoring the options' do
            object.save

            expect(object.name).to eq 'Washington Fuck Botelho'
          end
        end

        context 'with a filter that accepts options' do
          before { object.class.normalizy :name, with: { strip: { side: :left } } }

          it 'executes the filter with given options' do
            object.save

            expect(object.name).to eq 'Washington  Fuck  Botelho  '
          end
        end
      end

      context 'as a module' do
        context 'with just one arg (input)' do
          before { object.class.normalizy :name, with: Normalizy::Filters::Blacklist1 }

          it 'receives the input value' do
            object.save

            expect(object.name).to eq '  Washington  filtered  Botelho  '
          end
        end

        context 'with two args (input, options) with' do
          before do
            object.class.normalizy :name, with: Normalizy::Filters::Blacklist2
          end

          it 'receives the input value with options' do
            object.save

            expect(object.name).to eq 'name:   Washington  Fuck  Botelho  '
          end
        end
      end

      context 'and block too' do
        let!(:block) { ->(value) { value.upcase } }

        before do
          Normalizy.configure do |config|
            config.add :blacklist, Normalizy::Filters::BlacklistBlock
          end
        end

        it 'runs after rules' do
          object.class.normalizy :name, with: :blacklist, &block

          object.save

          expect(object.name).to eq '  WASHINGTON  FUCK  BOTELHO  '
        end
      end
    end

    context 'when no filter match' do
      context 'and object has a method that responds' do
        context 'with no options on rule' do
          it 'runs the class method with self object on options' do
            object.class.normalizy :name, with: :custom_reverse

            object.save

            expect(object.name).to eq "'  ohletoB  kcuF  notgnihsaW  ' to '  Washington  Fuck  Botelho  '"
          end
        end

        context 'with no options on rule' do
          it 'runs the class method with given options and self object on it' do
            object.class.normalizy :name, with: { custom_reverse: {} }

            object.save

            expect(object.name).to eq "'  ohletoB  kcuF  notgnihsaW  ' to '  Washington  Fuck  Botelho  '"
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
