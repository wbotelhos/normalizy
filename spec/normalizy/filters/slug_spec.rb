# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Filters::Slug do
  describe 'default options' do
    it { expect(subject.call(nil)).to eq nil }
    it { expect(subject.call('')).to  eq '' }

    it { expect(subject.call('The Title')).to eq 'the-title' }
  end

  describe 'to' do
    it { expect(subject.call(nil        , to: :slug)).to eq nil }
    it { expect(subject.call(''         , to: :slug)).to eq '' }
    it { expect(subject.call('The Title', to: :slug)).to eq 'the-title' }

    context 'when is not :to key' do
      it { expect(subject.call(nil        , from: :slug)).to eq nil }
      it { expect(subject.call(''         , from: :slug)).to eq '' }
      it { expect(subject.call('The Title', from: :slug)).to eq 'the-title' }
    end
  end
end
