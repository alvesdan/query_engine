module QueryEngine
  module Matchable
    class Ilike < Default
      def matches?(value)
        fail Errors::QueryError unless value.is_a?(String)
        fail Errors::QueryError unless @document[@attribute].is_a?(String)
        !(@document[@attribute] =~ /#{Regexp.escape(value)}/i).nil?
      end
    end
  end
end
