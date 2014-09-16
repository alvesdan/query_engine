require 'spec_helper'

module QueryEngine
  describe Matchable do

    describe '$not' do
      let(:query) do
        {
          '$not' => [
            { a: 1 },
            { b: 2 }
          ]
        }
      end

      let(:examples) do
        [
          [{ a: 1, b: 2}, false],
          [{ a: 2, b: 1}, true],
          [{ a: 1, b: 1}, false],
          [{ a: 2, b: 2}, false]
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
