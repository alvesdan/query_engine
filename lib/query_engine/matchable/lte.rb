module QueryEngine
  module Matchable
    class Lte < Default
      def matches?(value)
        fail Errors::QueryError unless value.is_a?(Numeric)
        fail Errors::QueryError unless @document[@attribute].is_a?(Numeric)
        @document[@attribute] <= value
      end
    end
  end
end
