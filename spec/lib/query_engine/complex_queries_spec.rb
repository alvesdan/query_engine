require 'spec_helper'

module QueryEngine
  describe Matchable do
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
