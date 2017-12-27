module SQL::AST
  abstract class Node
    def to_sql(visitor = Visitor.new)
      visitor.visit(self)
    end

    def ==(other : self) : Bool
      # FIXME: Quick productivity hack. Should not depend on
      #        the underlying visitor implementation.
      to_sql == other.to_sql
    end

    def and(other : self) : AST::And
      AST::And.new(self, other)
    end

    def or(other : self) : AST::Or
      AST::Or.new(self, other)
    end
  end

  class All < Node
  end
end
