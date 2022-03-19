# frozen_string_literal: true

RSpec.describe Normalizy::RSpec::Matcher, '.failure_message' do
  let!(:model) { Match }

  context 'with no :with expectation' do
    it do
      matcher = described_class.new(:downcase_field)

      matcher.from :from
      matcher.to :to
      matcher.matches? model.new

      expect(matcher.failure_message).to eq %(expected: "to"\n     got: "from")
    end
  end

  context 'with :with expectation' do
    it do
      matcher = described_class.new(:alone)

      matcher.with :missing
      matcher.matches? model.new

      expect(matcher.failure_message).to eq %(expected: missing\n     got: nil)
    end

    it do
      matcher = described_class.new(:downcase_field_array)

      matcher.with :missing
      matcher.matches? model.new

      expect(matcher.failure_message).to eq %(expected: missing\n     got: downcase)
    end

    it do
      matcher = described_class.new(:trim_side_left)

      matcher.with :missing
      matcher.matches? model.new

      expect(matcher.failure_message).to eq %(expected: missing\n     got: {:trim=>{:side=>:left}})
    end
  end
end
