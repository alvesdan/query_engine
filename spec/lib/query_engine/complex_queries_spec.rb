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

    let(:saturday_raining_tomorrow) do
      {
        '#forecast' => {
          '20140920' => {
            conditions: ['raining'],
            temperature: {
              max: 15,
              min: 10,
              average: 12.5
            }
          },
          '20140921' => {
            conditions: ['cloudy'],
            temperature: {
              max: 18,
              min: 12,
              average: 15
            }
          }
        },
        '#time' => {
          weekday: 6,
          hour: 9,
          minute: 17
        }
      }
    end

    let(:chelsea_playing_on_weekend) do
      {
        '#time' => {
          weekday: 6,
          hour: 16,
          minute: 5
        },
        '#tv' => {
          'sky' => {
            show: 'Sports Live'
          },
          'itv' => {
            show: 'Manchester vs Liverpool'
          }
        }
      }
    end

    let(:match_raining_weekday) do
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

    let(:match_saturday_raining_tomorrow) do
      {
        '$and' => [
          {
            '#forecast' => {
              '20140920' => {
                conditions: { '$any' => ['raining'] }
              }
            }
          },
          {
            '#time' => {
              weekday: 6
            }
          }
        ]
      }
    end

    let(:match_chelsea_playing_on_weekend) do
      {
        '$and' => [
          {
            '#tv' => {
              '$within_keys' => [
                {
                  show: { '$ilike' => 'Liverpool' }
                }
              ]
            }
          },
          {
            '#time' => {
              weekday: { '$in' => [0, 6] }
            }
          }
        ]
      }
    end

    it 'matches complex queries' do
      expect(described_class.matches?(raining_weekday, match_raining_weekday)).to be_truthy
      expect(described_class.matches?(saturday_raining_tomorrow, match_saturday_raining_tomorrow)).to be_truthy
      expect(described_class.matches?(chelsea_playing_on_weekend, match_chelsea_playing_on_weekend)).to be_truthy
    end
  end
end
