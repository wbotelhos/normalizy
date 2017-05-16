# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.matches?' do
  let!(:model)   { User }
  let!(:matcher) { described_class.new :name }
  let!(:object)  { model.new }

  before { model.normalizy_rules = {} }

  it 'caches the object' do
    matcher.matches?(object)

    expect(matcher.instance_variable_get(:@subject)).to eq object
  end

  context 'when .with is called' do
    before { matcher.with :blank }

    context 'but model do not has that attribute on normalizy' do
      specify { expect(matcher.matches?(object)).to eq false }
    end

    context 'and model has that attribute on normalizy' do
      before { model.normalizy :name }

      context 'with no filter' do
        specify { expect(matcher.matches?(object)).to eq false }
      end

      context 'with filter' do
        context 'different of expected' do
          let!(:matcher) { described_class.new :name }

          before { User.normalizy :name, with: :squish }

          specify { expect(matcher.matches?(User.new)).to eq false }
        end

        context 'equal of expected' do
          let!(:matcher) { described_class.new :name }

          context 'as symbol' do
            before do
              User.normalizy :name, with: :blank

              matcher.with :blank
            end

            specify { expect(matcher.matches?(User.new)).to eq true }
          end

          context 'as hash' do
            before do
              User.normalizy :name, with: { trim: { side: :left } }

              matcher.with(trim: { side: :left })
            end

            specify { expect(matcher.matches?(User.new)).to eq true }
          end

          context 'as array' do
            before do
              User.normalizy :name, with: [{ trim: { side: :left } }]

              matcher.with(trim: { side: :left })
            end

            specify { expect(matcher.matches?(User.new)).to eq true }
          end
        end
      end
    end
  end

  context 'when .with is not called' do
    context 'and :from output is different of :to' do
      before do
        matcher.from '1'
        matcher.to   '2'
      end

      specify { expect(matcher.matches?(object)).to eq false }
    end

    context 'and :from output is equal of :to' do
      before do
        matcher.from '1'
        matcher.to   '1'
      end

      specify { expect(matcher.matches?(object)).to eq true }
    end
  end
end
