module QueryEngine
  module Matchable
    class All < Default
      def matches?(value)
        raise StandardError unless value.is_a?(Array)
        value.map { |item| @document[@attribute].include?(item) }.all?
      end
    end
  end
end
