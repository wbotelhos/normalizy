# frozen_string_literal: true

RSpec.describe Normalizy::RSpec::Matcher, '.matches?' do
  let!(:object) { Match.new }

  it do
    matcher = described_class.new(:alone)

    matcher.matches?(object)

    expect(matcher.instance_variable_get(:@subject)).to eq object
  end

  context 'when .with is called' do
    it do
      matcher = described_class.new(:alone)

      matcher.with :missing

      expect(matcher.matches?(object)).to be(false)
    end

    it do
      matcher = described_class.new(:downcase_field)

      matcher.with :downcase

      expect(matcher.matches?(object)).to be(true)
    end

    it do
      matcher = described_class.new(:trim_side_left)

      matcher.with trim: { side: :left }

      expect(matcher.matches?(object)).to be(true)
    end

    it do
      matcher = described_class.new(:trim_side_left_array)

      matcher.with trim: { side: :left }

      expect(matcher.matches?(object)).to be(true)
    end

    it do
      Normalizy.configure do |config|
        config.default_filters = :squish
      end

      matcher = described_class.new(:alone)

      matcher.with :squish

      expect(matcher.matches?(object)).to be(true)
    end

    it do
      Normalizy.configure do |config|
        config.default_filters = [:squish]
      end

      matcher = described_class.new(:alone)

      matcher.with :squish

      expect(matcher.matches?(object)).to be(true)
    end

    it do
      Normalizy.configure do |config|
        config.default_filters = [{ strip: { side: :left } }]
      end

      matcher = described_class.new(:alone)

      matcher.with(strip: { side: :left })

      expect(matcher.matches?(object)).to be(true)
    end

    it do
      Normalizy.configure do |config|
        config.default_filters = :squish
      end

      matcher = described_class.new(:downcase_field)

      matcher.with :squish

      expect(matcher.matches?(object)).to be(false)
    end
  end

  context 'when .with is not called' do
    it do
      matcher = described_class.new(:alone)

      matcher.from '1'
      matcher.to   '2'

      expect(matcher.matches?(object)).to be(false)
    end

    it do
      matcher = described_class.new(:downcase_field)

      matcher.from 'BOTELHO'
      matcher.to   'botelho'

      expect(matcher.matches?(object)).to be(true)
    end
  end
end
