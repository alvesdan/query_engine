require 'spec_helper'

module QueryEngine
  describe Matchable do

    let(:document) do
      {
        a: [1, 2],
        b: 3,
        c: {
          d: 4
        }
      }
    end

    context 'with ignorable' do
      let(:query) do
        { c: { d: 4, ignoreme: :blah } }
      end

      it 'correctly ignores those keys' do
        expect(described_class.matches?(document, query, ignorable: ['ignoreme'])).to be true
      end
    end

    context 'without ignorable' do
      let(:query) do
        { c: { d: 4, ignoreme: :blah } }
      end

      it 'does not ignore those keys' do
        expect(described_class.matches?(document, query, ignorable: [])).to be false
      end
    end

    it 'matches correctly' do
      expect(described_class.matches?(document, a: [1, 2])).to be_truthy
      expect(described_class.matches?(document, a: 2)).to be_falsy
      expect(described_class.matches?(document, a: [1, 2], b: 4)).to be_falsy
      expect(described_class.matches?(document, a: [1, 2], b: 3)).to be_truthy
      expect(described_class.matches?(document, c: { d: 3})).to be_falsy
      expect(described_class.matches?(document, a: { '$all' => [1, 2]})).to be_truthy
      expect(described_class.matches?(document, a: { '$all' => [1, 2, 3]})).to be_falsy
      expect(described_class.matches?(document, a: { '$any' => [1, 3]})).to be_truthy
      expect(described_class.matches?(document, a: { '$any' => [3, 6]})).to be_falsy
      expect(described_class.matches?({a: 4}, a: { '$any' => [3, 6]})).to be_falsy
      expect(described_class.matches?({a: 3}, a: { '$any' => [3, 6]})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$gt' => 3}})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$gt' => 4}})).to be_falsy
      expect(described_class.matches?(document, c: { d: {'$lt' => 5}})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$lt' => 4}})).to be_falsy
      expect(described_class.matches?(document, c: { d: {'$lte' => 4}})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$lte' => 3}})).to be_falsy
      expect(described_class.matches?(document, c: { d: {'$gte' => 4}})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$gte' => 5}})).to be_falsy
    end

    it 'matches with symbols and strings' do
      expect(described_class.matches?(document, {'a' => [1, 2]})).to be_truthy
    end
  end
end
