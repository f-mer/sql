require "./node"

module SQL::AST
  abstract class Binary < Node
    property left, right

    @left : Node?
    @right : Node?

    def initialize(@left : Node, @right : Node)
    end

    def initialize(@left : Node)
    end

    def initialize
    end
  end

  class Select < Binary
  end

  class From < Binary
  end

  class Equal < Binary
  end

  class NotEqual < Binary
  end

  class GreaterThan < Binary
  end

  class GreaterThanOrEqual < Binary
  end

  class LessThan < Binary
  end

  class LessThanOrEqual < Binary
  end

  class InnerJoin < Binary
  end

  class On < Binary
  end

  class QualifiedColumn < Binary
  end

  class And < Binary
  end

  class Or < Binary
  end

  class Alias < Binary
  end

  class Insert < Binary
  end

  class Into < Binary
  end

  class Values < Binary
  end

  class In < Binary
  end
end
