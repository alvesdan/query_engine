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
      '$not' => Outer::Not,
      '$within_keys' => Outer::WithinKeys
    }

    WILDCARD = '$anything'

    def self.matches?(document, selector, ignorable: [])
      matchers = [true]
      document.deep_stringify_keys!
      selector.deep_stringify_keys!
      ignorable.map!(&:to_s)
      selector.each_pair do |key, value|
        if ignorable.include?(key)
          # ignore
        elsif wildcard?(value)
          matchers << document.key?(key)
        elsif operator?(key)
          matchers << operator_matcher(key, key, document, value,
                                       ignorable: ignorable)
        else
          if value.is_a?(Hash) && document.key?(key)
            if operator?(value.keys.first)
              if wildcard?(value.values.first)
                matchers << true
              else

                matchers << operator_matcher(value.keys.first, key, document, value.values.first)
              end
            else
              matchers << matches?(document[key], value, ignorable: ignorable)
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

    def self.wildcard?(obj)
      return false unless obj.is_a?(String)
      obj == WILDCARD
    end

    def self.operator_matcher(operator, key, document, value, ignorable: [])
      if outer_operator?(operator, value)
        doc = document.key?(key) ? document[key] : document
        OUTER_OPERATORS[operator].new(doc, value, ignorable: ignorable).matches?
      elsif OPERATORS.key?(operator)
        OPERATORS[operator].new(key, document).matches?(value)
      else
        raise Errors::NotImplemented.new("#{operator} has not been implemented")
      end
    end
  end
end
