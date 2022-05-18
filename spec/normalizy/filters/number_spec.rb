# frozen_string_literal: true

RSpec.describe Normalizy::Filters::Number do
  context 'with no cast' do
    it { expect(subject.call('abcdefghijklmnopkrstuvxyz')).to be(nil) }
    it { expect(subject.call('ABCDEFGHIJKLMNOPKRSTUVXYZ')).to be(nil) }
    it { expect(subject.call('áéíóúàâêôãõ')).to               be(nil) }
    it { expect(subject.call('0123456789')).to                eq '0123456789' }
    it { expect(subject.call('012345x6789')).to               eq '0123456789' }
    it { expect(subject.call("\n")).to                        be(nil) }
    it { expect(subject.call(42)).to                          eq 42 }
    it { expect(subject.call(nil)).to                         be(nil) }
    it { expect(subject.call('nil')).to                       be(nil) }
    it { expect(subject.call('')).to                          be(nil) }
    it { expect(subject.call('1 2 3')).to                     eq '123' }
  end

  context 'with :cast' do
    it { expect(subject.call('abcdefghijklmnopkrstuvxyz', cast: :to_i)).to be(nil) }
    it { expect(subject.call('ABCDEFGHIJKLMNOPKRSTUVXYZ', cast: :to_i)).to be(nil) }
    it { expect(subject.call('áéíóúàâêôãõ', cast: :to_i)).to               be(nil) }
    it { expect(subject.call('0123456789', cast: :to_i)).to                eq 123_456_789 }
    it { expect(subject.call('012345x6789', cast: :to_i)).to               eq 123_456_789 }
    it { expect(subject.call("\n", cast: :to_i)).to                        be(nil) }
    it { expect(subject.call(42, cast: :to_i)).to                          eq 42 }
    it { expect(subject.call(nil, cast: :to_i)).to                         be(nil) }
    it { expect(subject.call('nil', cast: :to_i)).to                       be(nil) }
    it { expect(subject.call('', cast: :to_i)).to                          be(nil) }
    it { expect(subject.call('1 2 3', cast: :to_i)).to                     eq 123 }
  end
end
