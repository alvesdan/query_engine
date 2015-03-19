module QueryEngine
  module Matchable
    module Outer
      class Default
        attr_reader :ignorable
        def initialize(document, queries, ignorable: [])
          @document = document
          @queries = queries
          @ignorable = ignorable
        end

        def matches?
          fail StandardError, 'Not Implemented'
        end

        private

        def matchables
          Array.new([]).tap do |matches|
            @queries.each { |query|
              matches << ::QueryEngine::Matchable
                .matches?(@document, query, ignorable: ignorable)
            }
          end
        end

        def matchable_documents
          matches = []
          @document.each do |key, value|
            @queries.each { |query|
              result = ::QueryEngine::Matchable
                .matches?(value, query, ignorable: ignorable)
              matches << result
              break if result
            }
          end
          matches
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

      class Not < Default
        def matches?
          matchables.none?
        end
      end

      class WithinKeys < Default
        def matches?
          matchable_documents.any?
        end
      end
    end
  end
end
