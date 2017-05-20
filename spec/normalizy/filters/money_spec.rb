# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Filters::Money do
  context 'with default options' do
    it { expect(subject.call('')).to eq nil }

    it { expect(subject.call(1)).to        be 1 }
    it { expect(subject.call(1.70)).to     be 1.70 }
    it { expect(subject.call(103.70)).to   be 103.70 }
    it { expect(subject.call(1030.70)).to  be 1030.70 }
    it { expect(subject.call(10_300.70)).to be 10_300.70 }

    it { expect(subject.call('0')).to        eq '0.00' }
    it { expect(subject.call('1.70')).to     eq '1.70' }
    it { expect(subject.call('103.70')).to   eq '103.70' }
    it { expect(subject.call('1030.70')).to  eq '1030.70' }
    it { expect(subject.call('10300.70')).to eq '10300.70' }

    it { expect(subject.call('$ 0.01')).to     eq '0.01' }
    it { expect(subject.call('$ 1')).to        eq '1.00' }
    it { expect(subject.call('$ 1.70')).to     eq '1.70' }
    it { expect(subject.call('$ 103.70')).to   eq '103.70' }
    it { expect(subject.call('$ 1030.70')).to  eq '1030.70' }
    it { expect(subject.call('$ 10300.70')).to eq '10300.70' }
  end

  context 'with :cast' do
    context 'when value has two decimal precision' do
      it { expect(subject.call('1.70'    , cast: :to_f)).to be 1.7 }
      it { expect(subject.call('103.70'  , cast: :to_f)).to be 103.7 }
      it { expect(subject.call('1030.70' , cast: :to_f)).to be 1030.7 }
      it { expect(subject.call('10300.70', cast: :to_f)).to be 10_300.7 }

      it { expect(subject.call('$ 1'       , cast: :to_f)).to be 1.0 }
      it { expect(subject.call('$ 1.70'    , cast: :to_f)).to be 1.7 }
      it { expect(subject.call('$ 103.70'  , cast: :to_f)).to be 103.7 }
      it { expect(subject.call('$ 1030.70' , cast: :to_f)).to be 1030.7 }
      it { expect(subject.call('$ 10300.70', cast: :to_f)).to be 10_300.7 }
    end

    context 'when value has one decimal precision' do
      it { expect(subject.call('1.7'    , cast: :to_f)).to eq 1.7 }
      it { expect(subject.call('103.7'  , cast: :to_f)).to eq 103.7 }
      it { expect(subject.call('1030.7' , cast: :to_f)).to eq 1030.7 }
      it { expect(subject.call('10300.7', cast: :to_f)).to eq 10_300.7 }

      it { expect(subject.call('$ 1.7'    , cast: :to_f)).to eq 1.7 }
      it { expect(subject.call('$ 103.7'  , cast: :to_f)).to eq 103.7 }
      it { expect(subject.call('$ 1030.7' , cast: :to_f)).to eq 1030.7 }
      it { expect(subject.call('$ 10300.7', cast: :to_f)).to eq 10_300.7 }

      context 'and calls cast' do
        it { expect(subject.call('1.7'    , cast: :to_f)).to be 1.7 }
        it { expect(subject.call('103.7'  , cast: :to_f)).to be 103.7 }
        it { expect(subject.call('1030.7' , cast: :to_f)).to be 1030.7 }
        it { expect(subject.call('10300.7', cast: :to_f)).to be 10_300.7 }

        it { expect(subject.call('$ 1.7'    , cast: :to_f)).to be 1.7 }
        it { expect(subject.call('$ 103.7'  , cast: :to_f)).to be 103.7 }
        it { expect(subject.call('$ 1030.7' , cast: :to_f)).to be 1030.7 }
        it { expect(subject.call('$ 10300.7', cast: :to_f)).to be 10_300.7 }
      end
    end

    context 'with no decimal precision' do
      it { expect(subject.call('1', type: :cents)).to eq '100' }
    end
  end

  context 'with :type options' do
    context 'as :cents' do
      it { expect(subject.call('', type: :cents)).to eq nil }

      it { expect(subject.call(1        , type: :cents)).to be 1 }
      it { expect(subject.call(1.70     , type: :cents)).to be 1.70 }
      it { expect(subject.call(103.70   , type: :cents)).to be 103.70 }
      it { expect(subject.call(1030.70  , type: :cents)).to be 1030.70 }
      it { expect(subject.call(10_300.70, type: :cents)).to be 10_300.70 }

      context 'with two decimal precision' do
        it { expect(subject.call('1.70'    , type: :cents)).to eq '170' }
        it { expect(subject.call('103.70'  , type: :cents)).to eq '10370' }
        it { expect(subject.call('1030.70' , type: :cents)).to eq '103070' }
        it { expect(subject.call('10300.70', type: :cents)).to eq '1030070' }

        it { expect(subject.call('$ 1'       , type: :cents)).to eq '100' }
        it { expect(subject.call('$ 1.70'    , type: :cents)).to eq '170' }
        it { expect(subject.call('$ 103.70'  , type: :cents)).to eq '10370' }
        it { expect(subject.call('$ 1030.70' , type: :cents)).to eq '103070' }
        it { expect(subject.call('$ 10300.70', type: :cents)).to eq '1030070' }

        context 'with :cast' do
          it { expect(subject.call('1.70'    , cast: :to_f, type: :cents)).to be 170.0 }
          it { expect(subject.call('103.70'  , cast: :to_f, type: :cents)).to be 10_370.0 }
          it { expect(subject.call('1030.70' , cast: :to_f, type: :cents)).to be 103_070.0 }
          it { expect(subject.call('10300.70', cast: :to_f, type: :cents)).to be 1_030_070.0 }

          it { expect(subject.call('$ 1'       , cast: :to_f, type: :cents)).to be 100.0 }
          it { expect(subject.call('$ 1.70'    , cast: :to_f, type: :cents)).to be 170.0 }
          it { expect(subject.call('$ 103.70'  , cast: :to_f, type: :cents)).to be 10_370.0 }
          it { expect(subject.call('$ 1030.70' , cast: :to_f, type: :cents)).to be 103_070.0 }
          it { expect(subject.call('$ 10300.70', cast: :to_f, type: :cents)).to be 1_030_070.0 }
        end
      end

      context 'with one decimal precision' do
        it { expect(subject.call('1.7'    , type: :cents)).to eq '170' }
        it { expect(subject.call('103.7'  , type: :cents)).to eq '10370' }
        it { expect(subject.call('1030.7' , type: :cents)).to eq '103070' }
        it { expect(subject.call('10300.7', type: :cents)).to eq '1030070' }

        it { expect(subject.call('$ 1.7'    , type: :cents)).to eq '170' }
        it { expect(subject.call('$ 103.7'  , type: :cents)).to eq '10370' }
        it { expect(subject.call('$ 1030.7' , type: :cents)).to eq '103070' }
        it { expect(subject.call('$ 10300.7', type: :cents)).to eq '1030070' }

        context 'with :cast' do
          it { expect(subject.call('1.7'    , cast: :to_f, type: :cents)).to be 170.0 }
          it { expect(subject.call('103.7'  , cast: :to_f, type: :cents)).to be 10_370.0 }
          it { expect(subject.call('1030.7' , cast: :to_f, type: :cents)).to be 103_070.0 }
          it { expect(subject.call('10300.7', cast: :to_f, type: :cents)).to be 1_030_070.0 }

          it { expect(subject.call('$ 1.7'    , cast: :to_f, type: :cents)).to be 170.0 }
          it { expect(subject.call('$ 103.7'  , cast: :to_f, type: :cents)).to be 10_370.0 }
          it { expect(subject.call('$ 1030.7' , cast: :to_f, type: :cents)).to be 103_070.0 }
          it { expect(subject.call('$ 10300.7', cast: :to_f, type: :cents)).to be 1_030_070.0 }
        end
      end

      context 'with no decimal precision' do
        it { expect(subject.call('1', type: :cents)).to eq '100' }
      end
    end
  end

  context 'with :separator options' do
    context 'provided via options rule' do
      it { expect(subject.call('1-2', separator: '-')).to eq '1.20' }
    end

    context 'provided I18n' do
      before do
        allow(I18n).to receive(:t).with('currency.format.separator', default: '.') { 'x' }
        allow(I18n).to receive(:t).with('currency.format.precision', default: 2) { 2 }
      end

      it { expect(subject.call('1x2')).to eq '1.20' }
    end

    context 'when not provided' do
      it { expect(subject.call('1.2')).to eq '1.20' }
    end
  end
end
