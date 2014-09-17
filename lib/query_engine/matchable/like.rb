module QueryEngine
  module Matchable
    class Like < Default
      def matches?(value)
        fail Errors::QueryError unless value.is_a?(String)
        fail Errors::QueryError unless @document[@attribute].is_a?(String)
        !(@document[@attribute] =~ /#{Regexp.escape(value)}/).nil?
      end
    end
  end
end
