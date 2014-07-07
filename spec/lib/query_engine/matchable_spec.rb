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

    let(:complex_document) do
      {
        'temperature' => {
          'min' => 10,
          'max' => 20
        },
        'conditions' => ['clear']
      }
    end

    it 'should run' do
      expect(described_class.matches?(document, a: [1, 2])).to be_truthy
      expect(described_class.matches?(document, a: 2)).to be_falsy
      expect(described_class.matches?(document, a: [1, 2], b: 4)).to be_falsy
      expect(described_class.matches?(document, a: [1, 2], b: 3)).to be_truthy
      expect(described_class.matches?(document, c: { d: 3})).to be_falsy
      expect(described_class.matches?(document, a: { '$all' => [1, 2]})).to be_truthy
      expect(described_class.matches?(document, a: { '$all' => [1, 2, 3]})).to be_falsy
      expect(described_class.matches?(document, a: { '$or' => [1, 3]})).to be_truthy
      expect(described_class.matches?(document, a: { '$or' => [3, 6]})).to be_falsy
      expect(described_class.matches?({a: 4}, a: { '$or' => [3, 6]})).to be_falsy
      expect(described_class.matches?({a: 3}, a: { '$or' => [3, 6]})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$gt' => 3}})).to be_truthy
      expect(described_class.matches?(document, c: { d: {'$gt' => 4}})).to be_falsy
    end

    it 'should find in complex document' do
      expect(described_class.matches?(complex_document, {'conditions' => ['clear']})).to be_truthy
      expect(described_class.matches?(complex_document, {'conditions' => {'$or' => ['clear', 'half clear']}})).to be_truthy
      expect(described_class.matches?(complex_document, {'conditions' => {'$or' => ['cloudy', 'half clear']}})).to be_falsy
    end

    it 'should change context when an outer operator receives a hash' do
      expect(described_class.matches?(complex_document, {'$or' => [{'conditions' => {'$or' => ['clear']}}, {'temperature' => '40'}]})).to be_truthy
      expect(described_class.matches?(complex_document, {'temperature' => {'$or' => [{'max' => 20}, {'min' => -5}]}})).to be_truthy
      expect(described_class.matches?(complex_document, {'temperature' => {'$and' => [{'max' => 20}, {'min' => -5}]}})).to be_falsy
      expect(described_class.matches?(complex_document, {'temperature' => {'$and' => [{'max' => 20}, {'min' => 10}]}})).to be_truthy
    end
  end
end
