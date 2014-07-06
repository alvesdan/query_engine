module QueryEngine
  module Matchable
    class Default
      def initialize(attribute, document)
        @attribute, @document = attribute, document
      end

      def matches?(value)
        @document[@attribute] == value
      end
    end
  end
end
