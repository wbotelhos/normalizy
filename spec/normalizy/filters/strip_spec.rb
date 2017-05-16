# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Filters::Strip do
  it { expect(subject.call('  Some  Text  ')).to               eq 'Some  Text' }
  it { expect(subject.call('  Some  Text  ', side: :left)).to  eq 'Some  Text  ' }
  it { expect(subject.call('  Some  Text  ', side: :right)).to eq '  Some  Text' }
  it { expect(subject.call('  Some  Text  ', side: :both)).to  eq 'Some  Text' }
  it { expect(subject.call("\n")).to                           eq '' }
  it { expect(subject.call(42)).to                             eq 42 }
  it { expect(subject.call(nil)).to                            eq nil }
end
