module QueryEngine
  module Matchable
    class Gt < Default
      def matches?(value)
        fail Errors::QueryError.new("Gt Value is not numeric") unless value.is_a?(Numeric)
        fail Errors::QueryError.new("Gt Value is not numeric") unless @document[@attribute].is_a?(Numeric)
        @document[@attribute] > value
      end
    end
  end
end
