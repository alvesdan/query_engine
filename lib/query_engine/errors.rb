module QueryEngine
  module Errors
    class Error < StandardError; end
    class NotImplemented < Error; end
    class Unsupported < Error; end
    class QueryError < Error; end
  end
end
