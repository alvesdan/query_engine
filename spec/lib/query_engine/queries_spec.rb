require 'spec_helper'

module QueryEngine
  describe Matchable do

    it 'returns true when query is empty' do
      expect(described_class.matches?({a: 1}, {})).to be_truthy
      expect(described_class.matches?({b: 'a'}, {})).to be_truthy
    end

    describe '$all' do
      let(:query) do
        { a: { '$all' => ['a', 'b'] } }
      end

      let(:examples) do
        [
          [{ a: [ 'a', 'b' ] }, true],
          [{ a: [ 'b', 'a' ] }, true],
          [{ a: 'a' }, false],
          [{ a: 'b' }, false],
          [{ a: 'd' }, false],
          [{ b: 'a'}, false],
          [{}, false]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$any' do
      let(:query) do
        { a: { '$any' => [ 'a', 'b' ] } }
      end

      let(:examples) do
        [
          [{ a: [ 'a', 'b' ] }, true],
          [{ a: [ 'b', 'a' ] }, true],
          [{ a: [ 'a' ] }, true],
          [{ a: [ 'b' ] }, true],
          [{ a: 'a' }, true],
          [{ a: 'b' }, true],
          [{ a: [ 'a', 'b', 'c' ]}, true],
          [{ a: 'd' }, false],
          [{ b: 'a'}, false],
          [{}, false]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$gt' do
      let(:query) do
        { a: { '$gt' => 1 } }
      end

      let(:examples) do
        [
          [{ a: 3 }, true],
          [{ a: 2 }, true],
          [{ a: 1 }, false],
          [{ a: 0 }, false],
          [{ b: 2 }, false],
          [{}, false],
          [{ a: 1, b: 1 }, false],
          [{ a: 2, b: 1 }, true]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$gte' do
      let(:query) do
        { a: { '$gte' => 1 } }
      end

      let(:examples) do
        [
          [{ a: 3 }, true],
          [{ a: 2 }, true],
          [{ a: 1 }, true],
          [{ a: 0 }, false],
          [{ b: 2 }, false],
          [{ a: 1, b: 1 }, true],
          [{ a: 2, b: 1 }, true]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$in' do
      let(:query) do
        { foo: { "$in" => ["a", "b"] } }
      end

      let(:examples) do
        [
          [{ foo: "a" }, true],
          [{ foo: "b" }, true],
          [{ foo: "c" }, false]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$lt' do
      let(:query) do
        { a: { '$lt' => 2 } }
      end

      let(:examples) do
        [
          [{ a: 0 }, true],
          [{ a: 1 }, true],
          [{ a: 2 }, false],
          [{ a: 3 }, false],
          [{ b: 2 }, false],
          [{}, false],
          [{ a: 2, b: 1 }, false],
          [{ a: 1, b: 1 }, true]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$lte' do
      let(:query) do
        { a: { '$lte' => 2 } }
      end

      let(:examples) do
        [
          [{ a: 0 }, true],
          [{ a: 1 }, true],
          [{ a: 2 }, true],
          [{ a: 3 }, false],
          [{ b: 2 }, false],
          [{}, false],
          [{ a: 2, b: 1 }, true],
          [{ a: 1, b: 1 }, true]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$or' do
      let(:query) do
        { '$or' => [ { a: 1 }, { b: 1 } ] }
      end

      let(:examples) do
        [
          [{ a: 1 }, true],
          [{ b: 1 }, true],
          [{ a: 1, b: 1 }, true],
          [{ a: 2, b: 1 }, true],
          [{ a: 2 }, false],
          [{ b: 2 }, false]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end

    describe '$or (nested)' do
      let(:query) do
        { nested: { '$or' => [ { a: 1 }, { b: 1 } ] } }
      end

      let(:examples) do
        [
          [{ nested: { a: 1 } }, true],
          [{ nested: { b: 1 } }, true],
          [{ nested: { a: 1, b: 1 } }, true],
          [{ nested: { a: 2, b: 1 } }, true],
          [{ nested: { a: 2 } }, false],
          [{ nested: { b: 2 } }, false],
          [{ nested: { foo: 2 } }, false],
          [{ missing: 'foo' }, false]
        ]
      end

      it 'should matches correctly' do
        examples.each do |example|
          expect(described_class.matches?(example[0], query)).to eq(example[1])
        end
      end
    end
  end
end
