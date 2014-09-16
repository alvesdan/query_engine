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

    # it 'should find in complex document' do
    #   expect(described_class.matches?(complex_document, {'conditions' => ['clear']})).to be_truthy
    #   expect(described_class.matches?(complex_document, {'conditions' => {'$or' => ['clear', 'half clear']}})).to be_truthy
    #   expect(described_class.matches?(complex_document, {'conditions' => {'$or' => ['cloudy', 'half clear']}})).to be_falsy
    # end

    let(:raining_weekday) do
      {
        '#weather' => {
          conditions: ['raining'],
          temperature: {
            max: 15,
            min: 10,
            average: 12.5
          }
        },
        '#time' => {
          weekday: 3,
          hour: 15,
          minute: 7
        }
      }
    end

    let(:one) do
      {
        '$and' => [
          {
            '#weather' => {
              conditions: { '$any' => ['raining', 'light_rain'] },
            }
          },
          {
            '#time' => {
              weekday: { '$any' => [1, 2, 3, 4, 5] }
            }
          }
        ]
      }
    end

    let(:two) do
      {
        '$and' => [
          {
            '#weather' => {
              conditions: { '$any' => ['light_rain'] },
            }
          },
          {
            '#time' => {
              weekday: { '$any' => [1, 2] }
            }
          }
        ]
      }
    end

    let(:three) do
      {
        '$or' => [
          {
            '#weather' => {
              conditions: { '$any' => ['raining'] },
            }
          },
          {
            '#time' => {
              weekday: { '$any' => [1, 2] }
            }
          }
        ]
      }
    end

    let(:four) do
      {
        '$and' => [
          {
            '#weather' => {
              conditions: { '$any' => ['raining'] },
            }
          },
          {
            '$or' => [
              {
                '#time' => { weekday: 5 }
              },
              {
                '#weather' => {
                  temperature: { max: {'$lt' => 10} }
                }
              }
            ]
          }
        ]
      }
    end

    let(:five) do
      {
        '#weather' => {
          temperature: { max: 15 }
        }
      }
    end

    it 'matches complex queries' do
      expect(described_class.matches?(raining_weekday, one)).to be_truthy
      expect(described_class.matches?(raining_weekday, two)).to be_falsey
      expect(described_class.matches?(raining_weekday, three)).to be_truthy
      expect(described_class.matches?(raining_weekday, four)).to be_falsey
      expect(described_class.matches?(raining_weekday, five)).to be_truthy
    end
  end
end
