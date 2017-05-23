# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::RSpec::Matcher, '.matches?' do
  let!(:object) { Match.new }

  specify do
    matcher = described_class.new(:alone)

    matcher.matches?(object)

    expect(matcher.instance_variable_get(:@subject)).to eq object
  end

  context 'when .with is called' do
    specify do
      matcher = described_class.new(:alone)

      matcher.with :missing

      expect(matcher.matches?(object)).to eq false
    end

    specify do
      matcher = described_class.new(:downcase_field)

      matcher.with :downcase

      expect(matcher.matches?(object)).to eq true
    end

    specify do
      matcher = described_class.new(:trim_side_left)

      matcher.with trim: { side: :left }

      expect(matcher.matches?(object)).to eq true
    end

    specify do
      matcher = described_class.new(:trim_side_left_array)

      matcher.with trim: { side: :left }

      expect(matcher.matches?(object)).to eq true
    end

    specify do
      Normalizy.configure do |config|
        config.default_filters = :squish
      end

      matcher = described_class.new(:downcase_field)

      matcher.with :squish

      expect(matcher.matches?(object)).to eq true
    end

    specify do
      Normalizy.configure do |config|
        config.default_filters = [:squish]
      end

      matcher = described_class.new(:downcase_field)

      matcher.with :squish

      expect(matcher.matches?(object)).to eq true
    end

    specify do
      Normalizy.configure do |config|
        config.default_filters = [{ strip: { side: :left } }]
      end

      matcher = described_class.new(:downcase_field)

      matcher.with(strip: { side: :left })

      expect(matcher.matches?(object)).to eq true
    end
  end

  context 'when .with is not called' do
    specify do
      matcher = described_class.new(:alone)

      matcher.from '1'
      matcher.to   '2'

      expect(matcher.matches?(object)).to eq false
    end

    specify do
      matcher = described_class.new(:downcase_field)

      matcher.from 'BOTELHO'
      matcher.to   'botelho'

      expect(matcher.matches?(object)).to eq true
    end
  end
end
