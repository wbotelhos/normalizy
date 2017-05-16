# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Config, '#alias' do
  context 'with no raw type' do
    let!(:object) { User.new name: 'Washington Botelho' }

    before do
      object.class.normalizy_rules = {}

      Normalizy.configure do |config|
        config.alias :email, :downcase
      end
    end

    it 'alias one filter to others' do
      object.class.normalizy :name, with: :email

      object.save

      expect(object.name).to eq 'washington botelho'
    end
  end

  context 'with raw type' do
    let!(:object) { User.new amount: 'R$ 4.200,00' }

    before { object.class.normalizy_rules = {} }

    context 'configured on setup' do
      before do
        Normalizy.configure do |config|
          config.alias :money, :number, raw: true
        end
      end

      it 'alias one filter to others' do
        object.class.normalizy :amount, with: :money

        object.save

        expect(object.amount).to eq 420_000
      end
    end

    context 'configured on normalizy' do
      before do
        Normalizy.configure do |config|
          config.alias :money, :number
        end
      end

      it 'alias one filter to others' do
        object.class.normalizy :amount, with: :money, raw: true

        object.save

        expect(object.amount).to eq 420_000
      end
    end
  end
end
