# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Normalizy::Filters::Number do
  it { expect(subject.call('abcdefghijklmnopkrstuvxyz')).to eq nil }
  it { expect(subject.call('ABCDEFGHIJKLMNOPKRSTUVXYZ')).to eq nil }
  it { expect(subject.call('áéíóúàâêôãõ')).to               eq nil }
  it { expect(subject.call('0123456789')).to                eq 123_456_789 }
  it { expect(subject.call("\n")).to                        eq nil }
  it { expect(subject.call(42)).to                          eq 42 }
  it { expect(subject.call(nil)).to                         eq nil }
  it { expect(subject.call('nil')).to                       eq nil }
  it { expect(subject.call('')).to                          eq nil }
end
