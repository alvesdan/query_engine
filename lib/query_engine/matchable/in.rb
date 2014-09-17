module QueryEngine
  module Matchable
    class In < Default
      def matches?(value)
        fail Errors::QueryError unless value.is_a?(Array)
        fail Errors::QueryError if @document[@attribute].is_a?(Array)
        value.include?(@document[@attribute])
      end
    end
  end
end
