module QueryEngine
  module Matchable
    class Or < Default
      def matches?(value)
        fail StandardError unless value.is_a?(Array)
        value.map { |item| search(@document[@attribute], item) }.any?
      end

      def search(value, item)
        value.is_a?(Array) ? value.include?(item) : (value == item)
      end
    end
  end
end
