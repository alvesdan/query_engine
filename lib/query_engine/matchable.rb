module QueryEngine
  module Matchable

    OPERATORS = {
      '$all' => All,
      '$any' => Any,
      '$gt' => Gt,
      '$lt' => Lt,
      '$gte' => Gte,
      '$lte' => Lte,
      '$in' => In,
      '$like' => Like,
      '$ilike' => Ilike
    }

    OUTER_OPERATORS = {
      '$or' => Outer::Or,
      '$and' => Outer::And,
      '$not' => Outer::Not
    }

    def self.matches?(document, selector)
      matchers = [true]
      selector.each_pair do |key, value|
        if operator?(key)
          matchers << operator_matcher(key, key, document, value)
        else
          if value.is_a?(Hash) && document.key?(key)
            if operator?(value.keys.first)
              matchers << operator_matcher(value.keys.first, key, document, value.values.first)
            else
              matchers << matches?(document[key], value)
            end
          else
            matchers << Default.new(key, document).matches?(value)
          end
        end
      end
      matchers.compact.all?
    end

    private

    def self.operator?(key)
      key.is_a?(String) && key.start_with?('$')
    end

    def self.outer_operator?(key, value)
      OUTER_OPERATORS.keys.include?(key) &&
        value.is_a?(Array) &&
        value.all? { |item| item.is_a?(Hash) }
    end

    def self.operator_matcher(operator, key, document, value)
      if outer_operator?(operator, value)
        doc = document.key?(key) ? document[key] : document
        return OUTER_OPERATORS[operator].new(doc, value).matches?
      else
        return OPERATORS[operator].new(key, document).matches?(value)
      end
    end
  end
end
