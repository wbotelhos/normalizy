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
    before { User.normalizy_rules = {} }

    context 'configured on setup' do
      before do
        Normalizy.configure do |config|
          config.alias :age, :number, raw: true
        end
      end

      it 'alias one filter to others' do
        User.normalizy :age, with: :age

        expect(User.create(age: '= 42').age).to eq 42
      end
    end

    context 'configured on normalizy' do
      before do
        Normalizy.configure do |config|
          config.alias :age, :number
        end
      end

      it 'alias one filter to others' do
        User.normalizy :age, with: :age, raw: true

        expect(User.create(age: '= 42').age).to eq 42
      end
    end
  end
end
