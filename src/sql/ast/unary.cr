require "./node"

module SQL::AST
  abstract class Unary(T) < Node
    property value

    def initialize(@value : T)
    end
  end

  class Table < Unary(String)
  end

  class Where < Unary(Node)
  end

  class Column < Unary(String)
  end

  class AST::String < Unary(String)
  end

  class Integer < Unary(Int32)
  end

  class ColumnList < Unary(Array(Node))
  end

  class ValueList < Unary(Array(Node))
  end

  class BindParam < Unary(Int32)
  end
end
