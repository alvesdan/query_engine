require 'spec_helper'

module QueryEngine
  describe Matchable do

    describe '$in (errors)' do
      let(:document) do
        { a: [1, 3, 4, 5] }
      end

      [
        { a: { '$in' => 'a' } },
        { a: { '$in' => 5 } },
        { a: { '$in' => { } } },
        { a: { '$in' => [ ] } }
      ].each do |example|
        it 'raises query error for invalid queries' do
          expect {
            described_class.matches?(document, example)
          }.to raise_error(Errors::QueryError)
        end
      end
    end

    describe '$gt (errors)' do
      let(:document) do
        { a: 1 }
      end

      [
        { a: { '$gt' => 'a' } },
        { a: { '$gt' => [ ] } },
        { a: { '$gt' => { } } }
      ].each do |example|
        it 'raises query error for invalid queries' do
          expect {
            described_class.matches?(document, example)
          }.to raise_error(Errors::QueryError)
        end
      end
    end
  end
end
