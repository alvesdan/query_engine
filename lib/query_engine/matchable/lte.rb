module QueryEngine
  module Matchable
    class Lte < Default
      def matches?(value)
        fail StandardError unless value.is_a?(Numeric)
        fail StandardError unless @document[@attribute].is_a?(Numeric)
        @document[@attribute] <= value
      end
    end
  end
end
