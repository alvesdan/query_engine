module QueryEngine
  module Matchable
    module Outer
      class Default
        def initialize(document, queries)
          @document = document
          @queries = queries
        end

        def matches?
          fail StandardError, 'Not Implemented'
        end

        private

        def matchables
          @queries.map { |selector|
            ::QueryEngine::Matchable.matches?(@document, selector)
          }
        end
      end

      class Or < Default
        def matches?
          matchables.any?
        end
      end

      class And < Default
        def matches?
          matchables.all?
        end
      end
    end
  end
end
