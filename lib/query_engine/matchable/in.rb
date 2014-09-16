module QueryEngine
  module Matchable
    class In < Default
      def matches?(value)
        fail StandardError unless value.is_a?(Array)
        fail StandardError if @document[@attribute].is_a?(Array)
        value.include?(@document[@attribute])
      end
    end
  end
end
